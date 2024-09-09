class CampaignMailerPreview < ActionMailer::Preview
  def send_campaign_email
    client = Client.first
    campaign = Campaign.first
    CampaignMailer.send_campaign_email(client, campaign)
  end
end
