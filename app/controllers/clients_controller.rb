class ClientsController < ApplicationController
  before_action :authenticate_manager!, only: [:destroy]

  def index
    if current_staff.manager?
      @clients = Client.all # Managers can see all clients
    else
      @clients = current_staff.clients # Staff sees only their clients
    end

    respond_to do |format|
      format.html { render :index } # Ensure the HTML response renders the index view
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("clients_list", partial: "clients/client_list", locals: { clients: @clients })
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
  end

  def new
    @client = Client.new
    @readonly = false # New client form is editable
  end

  def create
    @client = Client.new(client_params)

    if @client.save
      # Redirect to the show page or wherever you want to go after saving the client
      redirect_to @client, notice: 'Client was successfully created.'
    else
      # Render the new form again with error messages
      render :new
    end
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
      respond_to do |format|
        format.html { redirect_to @client, notice: 'Client was successfully updated.' }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.turbo_stream
      end
    end
  end

  def destroy
    @client = Client.find(params[:id])
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
        flash.now[:alert] = "No matching client found."
        render :search
      end
    else
      flash.now[:alert] = "Please enter at least one search criterion."
      render :search
    end
  end


  private

  private

  def client_params
    params.require(:client).permit(
      :type, :title, :first_name, :first_name_local, :last_name, :last_name_local,
      :birthday, :email, :phone, :address, :postal_code, :notes, :contact_preference,
      :time_to_contact, :size, :occupation, :vacation, :hobbies, :preference,
      :payment_type_visa, :payment_type_amex, :payment_type_mastercard,
      :payment_type_discover, :payment_type_other, :signature  # Ensure signature is permitted
    )
  end



  def authenticate_manager!
    unless current_staff&.role == "manager"
      redirect_to dashboard_path, alert: 'Only managers can delete clients.'
    end
  end
end
