class MessagesController < ApplicationController
  before_action :set_campaign, only: [:new, :create]
  before_action :set_client, only: [:create]

  def new
    @message = Message.new
    @client = Client.find(params[:client_id])
  end

  def create
    @message = Message.new(message_params)
    @message.campaign = @campaign
    @message.client = @client

    if @message.save
      campaign_assignment = CampaignAssignment.find_by(client_id: @message.client_id, campaign_id: @campaign.id)
      if campaign_assignment
        campaign_assignment.update_columns(message_sent: true)
        Rails.logger.info "Message sent and CampaignAssignment updated for Client: #{campaign_assignment.client_id}, Campaign: #{campaign_assignment.campaign_id}"

        respond_to do |format|
          format.html { redirect_to campaign_path(@campaign), notice: 'Message was successfully sent.' }
          format.turbo_stream {
            render turbo_stream: turbo_stream.replace("task_status_#{campaign_assignment.id}",
              partial: "success", locals: { campaign_assignment: campaign_assignment, client: @client })
          }
        end
      else
        Rails.logger.error "Failed to send message: #{@message.errors.full_messages.join(', ')}"
        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }
          format.turbo_stream { render :new, status: :unprocessable_entity }
        end
      end
    end
  end

  private

  def set_campaign
    @campaign = Campaign.find(params[:campaign_id])
    Rails.logger.info "Set Campaign for Message: #{@campaign.id}"
  end

  def set_client
    Rails.logger.info "Params: #{params.inspect}"
    @client = Client.find(message_params[:client_id])
    Rails.logger.info "Set Client for Message: #{@client.id}"
  end

  def message_params
    params.require(:message).permit(:subject, :body, :client_id)
  end
end
