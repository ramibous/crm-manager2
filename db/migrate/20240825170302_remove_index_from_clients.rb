class RemoveIndexFromClients < ActiveRecord::Migration[7.1]
  def change
    remove_index :clients, name: "index_clients_on_client_id" if index_exists?(:clients, :client_id)
  end
end
