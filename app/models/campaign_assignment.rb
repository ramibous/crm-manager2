class CampaignAssignment < ApplicationRecord
  belongs_to :campaign
  belongs_to :client

  validates :campaign, presence: true
  validates :client, presence: true

end
