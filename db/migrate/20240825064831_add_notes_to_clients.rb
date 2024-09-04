class AddNotesToClients < ActiveRecord::Migration[7.1]
  def change
    add_column :clients, :notes, :text
  end
end
