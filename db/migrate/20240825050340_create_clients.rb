class CreateClients < ActiveRecord::Migration[7.1]
  def change
    create_table :clients do |t|
      t.string :title
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :email
      t.date :birthday
      t.text :address
      t.string :phone
      t.string :home_number
      t.string :client_id

      t.timestamps
    end
    add_index :clients, :client_id, unique: true
  end
end
