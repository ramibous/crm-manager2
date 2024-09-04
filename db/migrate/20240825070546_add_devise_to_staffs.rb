# frozen_string_literal: true

class AddDeviseToStaffs < ActiveRecord::Migration[7.1]
  def self.up
    change_table :staffs do |t|
      ## Database authenticatable
      # Comment out the email column since it already exists
      # t.string :email, null: false, default: ""

      t.string :encrypted_password, null: false, default: "" unless column_exists?(:staffs, :encrypted_password)

      ## Recoverable
      t.string   :reset_password_token unless column_exists?(:staffs, :reset_password_token)
      t.datetime :reset_password_sent_at unless column_exists?(:staffs, :reset_password_sent_at)

      ## Rememberable
      t.datetime :remember_created_at unless column_exists?(:staffs, :remember_created_at)

      ## Trackable
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      # Uncomment below if timestamps were not included in your original model.
      # t.timestamps null: false
    end

    # These indexes may already exist if the columns exist, so you can check before adding them
    add_index :staffs, :email, unique: true unless index_exists?(:staffs, :email)
    add_index :staffs, :reset_password_token, unique: true unless index_exists?(:staffs, :reset_password_token)
    # add_index :staffs, :confirmation_token,   unique: true
    # add_index :staffs, :unlock_token,         unique: true
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
