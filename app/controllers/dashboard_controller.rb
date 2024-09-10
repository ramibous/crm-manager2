class DashboardController < ApplicationController
  before_action :authenticate_staff!

  def index
    # Fetch clients based on the staff's role
    @clients = current_staff.role == 'manager' ? Client.all : current_staff.clients

    # Apply filtering by segment
    if params[:segment].present?
      segment_name = params[:segment]
      segment_range = Client::SEGMENTS.find { |name, _range| name == segment_name }&.last
      if segment_range
        @clients = @clients.select do |client|
          client.purchase_total.between?(segment_range.begin, segment_range.end)
        end
      end
    end

    # Apply filtering by period and spend
    if params[:period].present?
      spend_threshold = (params[:spend].presence || 0).to_i
      @clients = @clients.select do |client|
        purchase_total = client.purchase_history(params[:period]).values.sum
        purchase_total >= spend_threshold
      end
    end

    # Sort clients alphabetically by last name and then first name
    @clients = @clients.sort_by { |client| [client.last_name&.downcase || '', client.first_name&.downcase || ''] }

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
