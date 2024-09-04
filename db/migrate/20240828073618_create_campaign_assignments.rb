class CreateCampaignAssignments < ActiveRecord::Migration[7.1]
  def change
    create_table :campaign_assignments do |t|
      t.references :client, null: false, foreign_key: true
      t.references :campaign, null: false, foreign_key: true

      t.timestamps
    end
  end
end
