class AddSignatureToClients < ActiveRecord::Migration[7.1]
  def change
    add_column :clients, :signature, :text
  end
end
