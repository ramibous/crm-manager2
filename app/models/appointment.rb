class Appointment < ApplicationRecord
  belongs_to :client
  belongs_to :staff

  validates :title, presence: true
  validates :scheduled_at, presence: true
end
