class ClientsController < ApplicationController
  protect_from_forgery except: :load_more_timeline_items
  before_action :set_client, only: [:show, :edit, :update, :destroy, :details, :load_more_timeline_items]
  before_action :authenticate_manager!, only: :destroy

  def index
    @clients = if current_staff.manager?
                 Client.page(params[:page]).per(10)
               else
                 current_staff.clients.page(params[:page]).per(10)
               end

    Rails.logger.info "Clients in index: #{@clients.inspect}"

    respond_to do |format|
      format.html { render :index }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("clients_list", partial: "clients/client_list", locals: { clients: @clients })
      end
    end
  end

  def export
    @clients = if current_staff.manager?
                 Client.all
               else
                 current_staff.clients
               end

    Rails.logger.info "Clients being exported: #{@clients.inspect}"

    respond_to do |format|
      format.xlsx do
        render xlsx: "export", template: "clients/export"
      end
    end
  end

  def show
    @timeline_items = paginate_timeline_items(@client)

    Rails.logger.info "Timeline items for client #{@client.id}: #{@timeline_items.map { |item| item[:description] }}"

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def load_more_timeline_items
    page = (params[:page] || 1).to_i
    @timeline_items = paginate_timeline_items(@client).page(page).per(3)

    Rails.logger.info "Loading timeline items for page #{page}: #{@timeline_items.map { |item| item[:description] }}"

    respond_to do |format|
      format.js
    end
  end









  def details
    # Logic for details action
  end

  def new
    @client = Client.new
    @readonly = false
    Rails.logger.info "New client initialized: #{@client.inspect}"
  end

  def create
    @client = Client.new(client_params)
    @client.staff_id ||= current_staff.id if current_staff.manager?

    if @client.save
      @readonly = true
      respond_to do |format|
        format.html { render :new, notice: 'Client created successfully.' }
        format.turbo_stream
      end
    else
      @readonly = false
      respond_to do |format|
        format.html { render :new }
        format.turbo_stream
      end
    end
  end

  def edit
    # Logic for edit action
  end

  def update
    if @client.update(client_params)
      @readonly = true
      respond_to do |format|
        format.html { render :edit, notice: 'Client was successfully updated.' }
        format.turbo_stream
      end
    else
      @readonly = false
      respond_to do |format|
        format.html { render :edit }
        format.turbo_stream
      end
    end
  end

  def destroy
    if @client.destroy
      respond_to do |format|
        format.html { redirect_to dashboard_path, notice: 'Client was successfully deleted.' }
        format.turbo_stream { render turbo_stream: turbo_stream.remove("client_#{params[:id]}") }
      end
    else
      respond_to do |format|
        format.html { redirect_to dashboard_path, alert: 'Client could not be deleted.' }
        format.turbo_stream
      end
    end
  end

  def wishlist
    @wishlist_items = WishlistItem.includes(:client).all

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "wishlist_items_#{Date.today}",
               template: 'clients/wishlist.pdf.erb',
               layout: 'pdf.html',
               disposition: 'attachment'
      end
    end
  end

  def search
    search_params = params.permit(:first_name, :last_name, :email, :first_name_local, :last_name_local, :company, :location, :passport, :mobile, :customer_code)

    if search_params.values.any?(&:present?)
      query = []
      query_params = []

      search_params.each do |key, value|
        if value.present?
          query << "#{key} ILIKE ?"
          query_params << "%#{value}%"
        end
      end

      @clients = Client.where(query.join(" OR "), *query_params)

      if @clients.any?
        render :search_results
      else
        flash.now[:alert] = "No matching client found."
        render :search
      end
    else
      flash.now[:alert] = "Please enter at least one search criterion."
      render :search
    end
  end

  private

  def set_client
    @client = Client.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to dashboard_path, alert: 'Client not found.'
  end

  def client_params
    params.require(:client).permit(
      :type, :title, :first_name, :first_name_local, :last_name, :last_name_local,
      :birthday, :email, :phone, :address, :postal_code, :notes, :contact_preference,
      :time_to_contact, :signature,
      :size, :occupation, :vacation, :hobbies, :preference,
      :payment_type_visa, :payment_type_amex, :payment_type_mastercard,
      :payment_type_discover, :payment_type_other
    )
  end

  def authenticate_manager!
    unless current_staff&.role == "manager"
      redirect_to dashboard_path, alert: 'Only managers can delete clients.'
    end
  end

  def paginate_timeline_items(client)
    timeline_items = (
      client.appointments.map { |a| { id: a.id, date: a.scheduled_at, description: "Appointment: #{a.title}" } } +
      client.wishlist_items.map { |w| { id: w.id, date: w.created_at, description: "Wishlist: #{w.item_name} - Reference: #{w.item_reference}" } } +
      client.purchases.map { |p| { id: p.id, date: p.created_at, description: "Purchase at #{p.store}" } } +
      client.campaigns.map { |c| { id: c.id, date: c.start_date, description: "Campaign: #{c.name} - Start Date: #{c.start_date} - End Date: #{c.end_date}" } }
    )

    # Ensure uniqueness based on item ID and description
    timeline_items.uniq! { |item| [item[:id], item[:description]] }

    # Paginate the array
    Kaminari.paginate_array(timeline_items).page(params[:page]).per(3)
  end

end
