class CampaignsController < ApplicationController
  before_action :authenticate_staff!
  before_action :authenticate_manager!, only: [:new, :create, :edit, :update, :destroy]
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

  def new
    @campaign = Campaign.new
    @clients = Client.none # Initialize as empty relation
    Rails.logger.info "Initialized new Campaign: #{@campaign.inspect}"
  end

  def edit
    @campaign = Campaign.find(params[:id])
    @clients = Client.where(staff_id: @campaign.staff_id) # Filter clients by staff_id
    Rails.logger.info "Editing Campaign: #{@campaign.id}, Clients: #{@clients.map(&:id).join(', ')}"
  end

  def create
    @campaign = Campaign.new(campaign_params)
    Rails.logger.info "Creating Campaign with params: #{campaign_params}"

    if params[:campaign][:client_ids].blank?
      flash.now[:alert] = "Please select clients before saving the campaign."
      @clients = Client.where(staff_id: params[:campaign][:staff_id])
      render :new
    elsif @campaign.save
      assign_clients_to_campaign(@campaign)
      respond_to do |format|
        format.html { redirect_to campaigns_path, notice: 'Campaign was successfully created.' }
        format.turbo_stream
      end
    else
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
    @campaign = Campaign.find(params[:id])
    @campaign.destroy
    Rails.logger.info "Destroyed Campaign: #{@campaign.id}"

    respond_to do |format|
      format.html { redirect_to campaigns_url, notice: 'Campaign was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def load_clients
    staff_id = params[:staff_id] || params[:campaign][:staff_id]
    segment = params[:segment]

    Rails.logger.info "Loading clients for staff_id: #{staff_id}, segment: #{segment}"

    if staff_id.present?
      @clients = Client.where(staff_id: staff_id)

      # Filter clients by segment if a segment is selected
      if segment.present?
        @clients = @clients.select { |client| client.segment == segment }
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
      CampaignAssignment.find_or_create_by!(campaign: campaign, client_id: client_id, staff_id: campaign.staff_id)
      Rails.logger.info "Assigned Client #{client_id} to Campaign #{campaign.id}"
    end
  end
end
