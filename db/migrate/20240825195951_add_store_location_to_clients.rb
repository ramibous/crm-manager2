class AddStoreLocationToClients < ActiveRecord::Migration[7.1]
  def change
    add_column :clients, :store_location, :string
  end
end
