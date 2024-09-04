class CreateWishlistItems < ActiveRecord::Migration[7.1]
  def change
    create_table :wishlist_items do |t|
      t.references :client, null: false, foreign_key: true
      t.string :item_name
      t.string :item_reference

      t.timestamps
    end
  end
end
