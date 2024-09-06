class ClientsController < ApplicationController
  before_action :authenticate_manager!, only: [:destroy]

  def index
    if current_staff.manager?
      @clients = Client.all # Managers can see all clients
    else
      @clients = current_staff.clients # Staff sees only their clients
    end

    respond_to do |format|
      format.html { redirect_to dashboard_path }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("clients_list", partial: "campaigns/client_list", locals: { clients: @clients })
      end
    end
  end

  def show
    @client = Client.find(params[:id])
    @interactions = @client.interactions.order(created_at: :desc)
    Rails.logger.info "Client Purchase Total: #{@client.purchase_total}"
    Rails.logger.info "Client Segment: #{@client.segment}"
  end

  def details
    @client = Client.find(params[:id])
    # Additional logic for fetching more detailed data if necessary
  end

  def new
    @client = Client.new
  end

  def export
    @clients = Client.all # or apply your filtering logic here

    respond_to do |format|
      format.xlsx do
        render xlsx: 'export', handlers: [:axlsx], filename: "clients_#{Date.today}.xlsx"
      end
      format.pdf do
        begin
          Rails.logger.debug "Rendering PDF export..."
          render pdf: "clients_#{Date.today}",
                 template: 'clients/export',
                 disposition: 'attachment' # Forces the browser to download the file
        rescue => e
          Rails.logger.error "PDF generation failed: #{e.message}"
          redirect_to dashboard_path, alert: "PDF could not be generated."
        end
      end
    end
  end

  def edit
    @client = Client.find(params[:id])
  end

  def update
    @client = Client.find(params[:id])
    if @client.update(client_params)
      redirect_to dashboard_path, notice: 'Client was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @client = Client.find(params[:id])
    if @client.destroy
      redirect_to dashboard_path, notice: 'Client was successfully deleted.'
    else
      redirect_to dashboard_path, alert: 'Client could not be deleted.'
    end
  end

  def wishlist
    @wishlist_items = WishlistItem.includes(:client).all
    respond_to do |format|
      format.html # renders the wishlist view
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
        flash[:alert] = "No matching client found."
        render :search
      end
    else
      flash[:alert] = "Please enter at least one search criterion."
      render :search
    end
  end

  private

  def client_params
    params.require(:client).permit(:title, :first_name, :middle_name, :last_name, :email, :birthday, :address, :phone, :home_number, :postal_code, :notes)
  end

  def authenticate_manager!
    unless current_staff&.role == "manager"
      redirect_to dashboard_path, alert: 'Only managers can delete clients.'
    end
  end
end
