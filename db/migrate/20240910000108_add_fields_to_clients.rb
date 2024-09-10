class AddFieldsToClients < ActiveRecord::Migration[6.0]
  def change
    add_column :clients, :first_name_local, :string
    add_column :clients, :last_name_local, :string
    add_column :clients, :contact_preference, :string
    add_column :clients, :time_to_contact, :string
    add_column :clients, :size, :string
    add_column :clients, :occupation, :string
    add_column :clients, :vacation, :string
    add_column :clients, :hobbies, :string
    add_column :clients, :preference, :string
  end
end
