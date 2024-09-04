class CreateCampaigns < ActiveRecord::Migration[7.1]
  def change
    create_table :campaigns do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.references :staff, null: false, foreign_key: true

      t.timestamps
    end
  end
end
