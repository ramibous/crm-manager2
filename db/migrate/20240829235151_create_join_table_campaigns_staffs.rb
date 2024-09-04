class CreateJoinTableCampaignsStaffs < ActiveRecord::Migration[7.1]
  def change
    create_join_table :campaigns, :staffs do |t|
      t.index [:campaign_id, :staff_id]
      t.index [:staff_id, :campaign_id]
    end
  end
end
