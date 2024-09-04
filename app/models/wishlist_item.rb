class WishlistItem < ApplicationRecord
  belongs_to :client

  validates :item_name, presence: true
  validates :item_reference, presence: true
  # Add validations if needed for the new attributes
  validates :size, presence: false # Optional
  validates :color, presence: false # Optional
  validates :note, presence: false # Optional
end
