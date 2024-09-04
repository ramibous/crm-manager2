class AddPostalCodeToClients < ActiveRecord::Migration[7.1]
  def change
    add_column :clients, :postal_code, :string
  end
end
