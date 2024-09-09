class AddContactsCountToCampaigns < ActiveRecord::Migration[7.1]
  def change
    add_column :campaigns, :contacts_count, :integer
  end
end
