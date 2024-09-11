class CampaignMailer < ApplicationMailer
  def send_campaign_email(client, campaign)
    @client = client
    @campaign = campaign

    # Fetching the first image from the campaign, assuming you're using ActiveStorage with Cloudinary
    if @campaign.images.attached?
      # Get the URL for the first attached image
      @image_url = @campaign.images.first.service_url
    else
      @image_url = nil # Fallback in case no image is attached
    end

    mail(to: @client.email, subject: 'Your Campaign Details')
  end
end
