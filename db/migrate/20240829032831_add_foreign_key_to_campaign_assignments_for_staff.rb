class AddForeignKeyToCampaignAssignmentsForStaff < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :campaign_assignments, :staffs
  end
end
