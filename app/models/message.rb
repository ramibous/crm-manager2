class Message < ApplicationRecord
  belongs_to :client
  belongs_to :campaign
  has_one_attached :image
end
