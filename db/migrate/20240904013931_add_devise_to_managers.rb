# frozen_string_literal: true

class AddDeviseToManagers < ActiveRecord::Migration[6.0]
  def up
    change_table :managers do |t|
      # t.string :email,              null: false, default: "" # Remove this line
      t.string :encrypted_password, null: false, default: ""

      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      # Uncomment below if timestamps were not included in your original model.
      # t.timestamps null: false
    end

    add_index :managers, :email,                unique: true
    add_index :managers, :reset_password_token, unique: true
    # add_index :managers, :confirmation_token,   unique: true
    # add_index :managers, :unlock_token,         unique: true
  end

  def down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end
end
