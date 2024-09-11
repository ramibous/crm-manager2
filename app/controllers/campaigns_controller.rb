class CampaignsController < ApplicationController
  before_action :authenticate_staff!
  before_action :authenticate_manager!, only: [:new, :create, :edit, :update, :destroy, :send_campaign_email]
  before_action :set_campaign, only: [:show, :edit, :update, :destroy]

  def index
    if current_staff.manager?
      @campaigns = Campaign.order(created_at: :desc)
    else
      @campaigns = Campaign.joins(:campaign_assignments).where(campaign_assignments: { staff_id: current_staff.id }).order(created_at: :desc)
    end
    Rails.logger.info "Loaded Campaigns: #{@campaigns.map(&:id).join(', ')}"
  end

  def show
    if current_staff.manager?
      # Manager can see all campaigns
    else
      unless @campaign.staff_id == current_staff.id || @campaign.staffs.exists?(id: current_staff.id)
        redirect_to campaigns_path, alert: "You are not authorized to view this campaign."
        return
      end
    end

    Rails.logger.info "Showing Campaign: #{@campaign.id}"

    respond_to do |format|
      format.html # renders show.html.erb
      format.turbo_stream # renders show.turbo_stream.erb if available
    end
  end

  def send_campaign_email
    client = Client.find(params[:client_id])
    campaign = Campaign.find(params[:campaign_id])
    CampaignMailer.send_campaign_email(client, campaign).deliver_now
    redirect_to campaign_path(campaign), notice: 'Campaign email sent successfully!'
  end

  def new
    @campaign = Campaign.new
    @clients = Client.none # Initialize as empty relation
    Rails.logger.info "Initialized new Campaign: #{@campaign.inspect}"
  end

  def edit
    @clients = Client.where(staff_id: @campaign.staff_id) # Filter clients by staff_id
    Rails.logger.info "Editing Campaign: #{@campaign.id}, Clients: #{@clients.map(&:id).join(', ')}"
  end

  def create
    # Log the client_ids to verify that they are being passed correctly
    Rails.logger.info "Params: #{params[:campaign][:client_ids]}"

    @campaign = Campaign.new(campaign_params.except(:client_ids))
    Rails.logger.info "Creating Campaign with params: #{campaign_params.except(:client_ids)}"

    # Check if any of the selected clients are invalid
    invalid_clients = Client.where(id: params[:campaign][:client_ids]).reject(&:valid?)

    if invalid_clients.any?
      Rails.logger.error "Invalid clients: #{invalid_clients.map(&:full_name).join(', ')}"
      flash.now[:alert] = "Some clients are invalid: #{invalid_clients.map(&:full_name).join(', ')}. Please ensure they have a valid phone number and signature."
      @clients = Client.where(staff_id: params[:campaign][:staff_id])
      render :new
    elsif @campaign.save
      params[:campaign][:client_ids].each do |client_id|
        client = Client.find(client_id)
        assignment = CampaignAssignment.new(campaign: @campaign, client: client, staff_id: @campaign.staff_id)

        if assignment.save
          Rails.logger.info "Assigned client #{client_id} to campaign #{@campaign.id}"
        else
          Rails.logger.error "Failed to assign client #{client_id} to campaign #{@campaign.id}: #{assignment.errors.full_messages.join(', ')}"
        end
      end

      respond_to do |format|
        format.html { redirect_to campaigns_path, notice: 'Campaign was successfully created.' }
        format.turbo_stream
      end
    else
      Rails.logger.error "Failed to create campaign: #{@campaign.errors.full_messages.join(', ')}"
      flash.now[:alert] = "Failed to create campaign."
      @clients = Client.where(staff_id: params[:campaign][:staff_id])
      render :new
    end
  end

  def update
    if params[:campaign][:client_ids].blank?
      flash.now[:alert] = "Please select clients before saving the campaign."
      @clients = Client.where(staff_id: params[:campaign][:staff_id])
      render :edit
    elsif @campaign.update(campaign_params)
      assign_clients_to_campaign(@campaign)
      respond_to do |format|
        format.html { redirect_to campaigns_path, notice: 'Campaign was successfully updated.' }
        format.turbo_stream
      end
    else
      flash.now[:alert] = "Failed to update campaign."
      @clients = Client.where(staff_id: params[:campaign][:staff_id])
      render :edit
    end
  end

  def destroy
    @campaign.destroy
    Rails.logger.info "Destroyed Campaign: #{@campaign.id}"

    respond_to do |format|
      format.html { redirect_to campaigns_url, notice: 'Campaign was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def load_clients
    staff_id = params[:staff_id]
    segment = params[:segment]

    Rails.logger.info "Loading clients for staff_id: #{staff_id}, segment: #{segment}"

    if staff_id.present?
      @clients = Client.where(staff_id: staff_id)

      # Apply segment filter
      case segment
      when 'no_purchase'
        @clients = @clients.left_outer_joins(:purchases).where(purchases: { id: nil })
      else
        @clients = @clients.select { |client| client.segment == segment } if segment.present?
      end

      Rails.logger.info "Clients loaded: #{@clients.map(&:id).join(', ')}"
    else
      @clients = Client.none
      Rails.logger.info "No clients loaded because no staff ID was found."
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("client-select-container", partial: "campaigns/client_list", locals: { clients: @clients })
      end
    end
  end

  private

  def campaign_params
    params.require(:campaign).permit(:name, :description, :start_date, :end_date, :staff_id, images: [], client_ids: [])
  end

  def set_campaign
    @campaign = Campaign.find(params[:id])
    Rails.logger.info "Set Campaign: #{@campaign.id}"
  end

  def assign_clients_to_campaign(campaign)
    Array(params[:campaign][:client_ids]).each do |client_id|
      client = Client.find_by(id: client_id)

      if client
        assignment = CampaignAssignment.new(campaign: campaign, client: client, staff_id: campaign.staff_id)

        if assignment.save
          Rails.logger.info "Successfully assigned Client #{client_id} to Campaign #{campaign.id}"
        else
          Rails.logger.error "Failed to assign Client #{client_id} to Campaign #{campaign.id}: #{assignment.errors.full_messages.join(', ')}"
        end
      else
        Rails.logger.error "Client #{client_id} not found. Skipping assignment."
      end
    end
  end
end
