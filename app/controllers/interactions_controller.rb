# app/controllers/interactions_controller.rb
class InteractionsController < ApplicationController
  def new
    @client = Client.find(params[:client_id])
    @interaction = @client.interactions.new
  end

  def create
    @client = Client.find(params[:client_id])
    @interaction = @client.interactions.build(interaction_params)
    if @interaction.save
      redirect_to client_path(@client), notice: 'Interaction added successfully.'
    else
      render :new
    end
  end

  private

  def interaction_params
    params.require(:interaction).permit(:interaction_type, :content)
  end
end
