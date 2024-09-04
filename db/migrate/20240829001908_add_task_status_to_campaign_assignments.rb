class AddTaskStatusToCampaignAssignments < ActiveRecord::Migration[7.1]
  def change
    add_column :campaign_assignments, :task_status, :string
  end
end
