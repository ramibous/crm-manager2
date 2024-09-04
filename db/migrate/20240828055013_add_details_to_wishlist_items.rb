class AddDetailsToWishlistItems < ActiveRecord::Migration[6.1]
  def change
    add_column :wishlist_items, :size, :string
    add_column :wishlist_items, :color, :string
    add_column :wishlist_items, :note, :text
    # The line below is causing the error because `created_at` already exists
    # add_column :wishlist_items, :created_at, :datetime
  end
end
