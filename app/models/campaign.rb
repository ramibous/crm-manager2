class Campaign < ApplicationRecord
  has_many :campaign_assignments, dependent: :destroy
  has_many :staffs, through: :campaign_assignments
  has_many :clients, through: :campaign_assignments
  has_many :messages, dependent: :destroy

  belongs_to :staff, class_name: 'Staff', foreign_key: 'staff_id'

  has_many_attached :images

  validates :name, :start_date, :end_date, presence: true

  after_create :add_to_client_timelines

  private

  def add_to_client_timelines
    clients.each do |client|
      client.interactions.create!(
        interaction_type: 'Campaign Created',
        description: "Campaign '#{name}' was created and assigned to you.",
        staff_id: staff_id
      )
    end
  end
end
