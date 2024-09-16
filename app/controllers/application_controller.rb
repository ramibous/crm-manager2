class ApplicationController < ActionController::Base
  before_action :authenticate_staff! # Ensure the user is authenticated

  helper_method :manager? # Expose the `manager?` method to views

  # Restrict actions to managers only
  def authenticate_manager!
    unless manager?
      Rails.logger.debug "Debug: You are not a manager. Your role is: #{current_staff.role}"
      redirect_to dashboard_path, alert: 'Only managers can perform this action.'
    end
  end

  # Helper method to check if the current user is a manager
  def manager?
    current_staff.manager?
  end
end
# force rebuild
