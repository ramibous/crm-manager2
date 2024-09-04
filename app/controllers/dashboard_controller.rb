class DashboardController < ApplicationController
  before_action :authenticate_staff!

  def index
    @clients = current_staff.role == 'manager' ? Client.all : current_staff.clients

    # Apply filtering by segment
    if params[:segment].present?
      segment_name = params[:segment]
      segment_range = Client::SEGMENTS.find { |name, range| name == segment_name }&.last
      @clients = @clients.select { |client| segment_range.cover?(client.purchase_total) } if segment_range
    end

    # Apply filtering by period and spend
    if params[:period].present?
      spend_threshold = (params[:spend].presence || 0).to_i
      @clients = @clients.select do |client|
        purchase_total = client.purchase_history(params[:period]).values.sum
        Rails.logger.debug "Client ID: #{client.id} | Period: #{params[:period]} | Purchase Total: #{purchase_total}"
        purchase_total >= spend_threshold
      end
    end

    Rails.logger.debug "Filtered Clients: #{@clients.map(&:id)}"

    # Fetch upcoming birthdays within the current month
    @upcoming_birthdays = @clients.select do |client|
      client.birthday.present? &&
      client.birthday.month == Date.today.month &&
      client.birthday.day >= Date.today.day
    end

    # Fetch upcoming campaigns starting today or later
    @upcoming_campaigns = current_staff.campaigns.where("start_date >= ?", Date.today).order(:start_date)
  end
end
