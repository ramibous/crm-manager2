class AddPaymentTypesToClients < ActiveRecord::Migration[7.1]
  def change
    add_column :clients, :payment_type_visa, :boolean
    add_column :clients, :payment_type_amex, :boolean
    add_column :clients, :payment_type_mastercard, :boolean
    add_column :clients, :payment_type_discover, :boolean
    add_column :clients, :payment_type_other, :boolean
  end
end
