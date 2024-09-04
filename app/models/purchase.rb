class Purchase < ApplicationRecord
  belongs_to :client

  # You can add any validations if needed, like:
  validates :product_name, presence: true
  validates :amount, :date, :product_name, presence: true
end
