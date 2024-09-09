class Message < ApplicationRecord
  belongs_to :client
  belongs_to :campaign
  has_one_attached :image

  # Validations
  validates :subject, presence: true  # Replace 'content' with 'subject'
  validates :body, presence: true     # Replace 'content' with 'body'

  # Scopes
  scope :opened, -> { where(opened: true) }
  scope :unopened, -> { where(opened: false) }

  # Callbacks
  after_create :notify_client

  private

  def notify_client
    # Logic to notify the client about the new message (e.g., via email or notification system)
  end
end
