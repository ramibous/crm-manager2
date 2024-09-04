class AddStoreToPurchases < ActiveRecord::Migration[7.1]
  def change
    add_column :purchases, :store, :string
  end
end
