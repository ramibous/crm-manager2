class StaffsController < ApplicationController
  def clients
    @clients = Staff.find(params[:id]).clients

    respond_to do |format|
      format.turbo_stream
    end
  end
end
