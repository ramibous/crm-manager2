class CampaignAssignment < ApplicationRecord
  belongs_to :campaign
  belongs_to :client
  belongs_to :staff # Assuming staff must be assigned to the assignment

  # Validations to ensure presence of required fields
  validates :campaign_id, :client_id, :staff_id, presence: true
end
