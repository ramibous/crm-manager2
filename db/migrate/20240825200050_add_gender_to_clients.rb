class AddGenderToClients < ActiveRecord::Migration[7.1]
  def change
    add_column :clients, :gender, :string
  end
end
