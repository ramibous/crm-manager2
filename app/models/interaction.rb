class Interaction < ApplicationRecord
  belongs_to :client
  belongs_to :staff

  validates :interaction_type, presence: true
  validates :description, presence: true
end
