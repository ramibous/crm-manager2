class CampaignMailer < ApplicationMailer
  def send_campaign(client, campaign)
    @client = client
    @campaign = campaign

    mail(to: @client.email, subject: "Exciting Campaign: #{@campaign.name}")
  end
end
