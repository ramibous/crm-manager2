class AddManagerToClients < ActiveRecord::Migration[7.1]
  def change
    add_reference :clients, :manager, null: false, foreign_key: true
  end
end
