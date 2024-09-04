class DropManagersTable < ActiveRecord::Migration[7.1]
  def up
    # Remove the foreign key from the clients table that references the managers table
    remove_foreign_key :clients, :managers

    # If there is an index on the manager_id column in the clients table, you may want to remove it too
    remove_index :clients, :manager_id if index_exists?(:clients, :manager_id)

    # Now you can safely drop the managers table
    drop_table :managers
  end

  def down
    create_table :managers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip
      t.timestamps
    end

    add_index :managers, :email, unique: true
    add_index :managers, :reset_password_token, unique: true

    # Re-add the foreign key
    add_foreign_key :clients, :managers
  end
end
