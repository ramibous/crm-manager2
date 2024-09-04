class CreateInteractions < ActiveRecord::Migration[7.0]
  def change
    create_table :interactions do |t|
      t.string :interaction_type
      t.references :client, null: false, foreign_key: true
      t.references :staff, null: false, foreign_key: true

      t.timestamps  # This adds `created_at` and `updated_at` columns
    end
  end
end
