class AddStaffIdToCampaignAssignments < ActiveRecord::Migration[7.1]
  def change
    add_column :campaign_assignments, :staff_id, :bigint
  end
end
