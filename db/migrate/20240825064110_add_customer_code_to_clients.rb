class AddCustomerCodeToClients < ActiveRecord::Migration[7.1]
  def change
    add_column :clients, :customer_code, :string
  end
end
