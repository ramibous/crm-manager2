class AddTypeToClients < ActiveRecord::Migration[7.1]
  def change
    add_column :clients, :type, :string
  end
end
