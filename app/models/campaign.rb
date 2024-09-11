class Campaign < ApplicationRecord
  has_many :campaign_assignments, dependent: :destroy
  has_many :clients, through: :campaign_assignments
  has_many :messages, dependent: :destroy

  belongs_to :staff, class_name: 'Staff', foreign_key: 'staff_id'

  has_many_attached :images

  validates :name, :start_date, :end_date, presence: true

  after_create :add_to_client_timelines



  # Retrieve the URL of the first image (main image)
  def main_image_url
    images.first.service_url if images.attached?
  end

  # Retrieve the URLs of the remaining images (secondary images)
  def secondary_images
    images[1..].map(&:service_url) if images.attached?
  end

  # Calculate the opens percentage
  def opens_percentage
    total_sent = clients.joins(:messages).count
    return 0 if total_sent.zero?

    total_opened = clients.joins(:messages).where(messages: { opened: true }).distinct.count
    ((total_opened.to_f / total_sent) * 100).round(2)
  end

  # Calculate the clicks percentage
  def clicks_percentage
    total_sent = clients.joins(:messages).count
    return 0 if total_sent.zero?

    total_clicked = clients.joins(:messages).where(messages: { clicked: true }).distinct.count
    ((total_clicked.to_f / total_sent) * 100).round(2)
  end

  # Calculate the unsubscribes percentage
  def unsubscribes_percentage
    total_sent = clients.joins(:messages).count
    return 0 if total_sent.zero?

    total_unsubscribed = clients.joins(:messages).where(messages: { unsubscribed: true }).distinct.count
    ((total_unsubscribed.to_f / total_sent) * 100).round(2)
  end

  private

  # Adds the campaign creation to each client's interaction timeline
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
