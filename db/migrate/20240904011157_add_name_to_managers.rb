class AddNameToManagers < ActiveRecord::Migration[7.1]
  def change
    add_column :managers, :name, :string
  end
end
