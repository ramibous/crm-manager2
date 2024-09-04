class AddDescriptionAndImageToCampaigns < ActiveRecord::Migration[7.1]
  def change
    add_column :campaigns, :description, :text
    add_column :campaigns, :image, :string
  end
end
