class Task < ApplicationRecord
  belongs_to :staff
  belongs_to :campaign
end
