class AppointmentsController < ApplicationController
  before_action :set_client, only: [:new, :create]

  def index
    @appointments = Appointment.includes(:client).order(scheduled_at: :asc)
  end

  def new
    @appointment = @client.appointments.new
  end

  def create
    @appointment = @client.appointments.new(appointment_params)
    @appointment.staff = current_staff  # Assign the current staff member

    if @appointment.save
      redirect_to @client, notice: 'Appointment was successfully created.'
    else
      Rails.logger.debug @appointment.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @appointment.update(appointment_params)
      redirect_to @appointment, notice: 'Appointment was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_client
    @client = Client.find(params[:client_id])
  end

  def appointment_params
    params.require(:appointment).permit(:title, :scheduled_at, :note)
  end
end
