class AddCampaignTypeToCampaigns < ActiveRecord::Migration[7.1]
  def change
    add_column :campaigns, :campaign_type, :string
  end
end
