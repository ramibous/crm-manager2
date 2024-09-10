class ClientsController < ApplicationController
  before_action :authenticate_manager!, only: [:destroy]

  def index
    if current_staff.manager?
      @clients = Client.all # Managers can see all clients
    else
      @clients = current_staff.clients # Staff sees only their clients
    end

    respond_to do |format|
      format.html { render :index }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("clients_list", partial: "clients/client_list", locals: { clients: @clients })
      end
    end
  end

  def show
    @client = Client.find(params[:id])
    @interactions = @client.interactions.order(created_at: :desc)
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
      @readonly = true # Set the form to read-only after creating the client
      respond_to do |format|
        format.html { render :new, notice: 'Client created successfully.' } # Stay on the same page
        format.turbo_stream
      end
    else
      @readonly = false # Keep form editable if validation fails
      respond_to do |format|
        format.html { render :new } # Render the same form with errors
        format.turbo_stream
      end
    end
  end

  def edit
    @client = Client.find(params[:id])
  end

  def update
    @client = Client.find(params[:id])
    if @client.update(client_params)
      @readonly = true # Set the form to read-only after update
      respond_to do |format|
        format.html { render :edit, notice: 'Client was successfully updated.' } # Stay on the same page
        format.turbo_stream
      end
    else
      @readonly = false # Keep form editable if validation fails
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

  private

  def client_params
    params.require(:client).permit(
      :type, :title, :first_name, :first_name_local, :last_name, :last_name_local,
      :birthday, :email, :phone, :address, :postal_code, :notes, :contact_preference,
      :time_to_contact, :signature,  # Ensure `signature` is permitted
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
end
