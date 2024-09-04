class AddMessageSentToCampaignAssignments < ActiveRecord::Migration[6.1]
  def change
    add_column :campaign_assignments, :message_sent, :boolean, default: false
  end
end
