class Client < ApplicationRecord
  belongs_to :staff, optional: true
  belongs_to :manager, optional: true
  has_many :purchases, -> { distinct }, dependent: :destroy
  has_many :interactions, dependent: :destroy
  has_many :appointments, -> { distinct }, dependent: :destroy
  has_many :wishlist_items, -> { distinct }, dependent: :destroy
  has_many :campaign_assignments, -> { distinct }, dependent: :destroy
  has_many :campaigns, -> { distinct }, through: :campaign_assignments
  has_many :messages, dependent: :destroy

  before_create :generate_client_id

  # Ensure that mandatory fields are filled in
  validates :first_name, :last_name, :email, :phone, presence: true
  validate :validate_signature_after_required_fields

  SEGMENTS = [
    ['no_purchase', 0..0],
    ['sleepers', 1..500],
    ['aspiring', 501..1000],
    ['experiencer', 1001..3000],
    ['potential_vic', 3001..5000],
    ['vic1', 5001..10000],
    ['vic2', 10001..20000],
    ['vic3', 20001..30000],
    ['vic4', 30001..40000],
    ['vic5', 40001..Float::INFINITY]
  ].freeze

  def purchase_total
    @purchase_total ||= purchases.sum(:amount)
  end

  def initials
    "#{first_name.first}#{last_name.first}".upcase
  end

  def purchase_history(period)
    case period
    when "yearly"
      purchases.group_by_year(:date).sum(:amount)
    when "quarterly"
      purchases.group_by_quarter(:date).sum(:amount)
    when "monthly"
      purchases.group_by_month(:date).sum(:amount)
    else
      {} # Return an empty hash if the period is not recognized
    end
  end

  def segment
    total_spent = purchase_total
    SEGMENTS.each do |segment_name, range|
      return segment_name if range.include?(total_spent)
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def timeline_items
    items = appointments.map { |a| { date: a.scheduled_at, description: "Appointment: #{a.title}" } }
    items += wishlist_items.map { |w| { date: w.created_at, description: "Wishlist: #{w.item_name} - Reference: #{w.item_reference}" } }

    # Filter out purchases with missing store names and ensure no duplicates
    items += purchases.map { |p| { date: p.created_at, description: "Purchase at #{p.store}" } if p.store.present? }.compact
    items += campaigns.map { |c| { date: c.start_date, description: "Campaign: #{c.name}" } }

    # Ensure uniqueness of items based on both date and description
    items.uniq { |item| [item[:date], item[:description]] }.sort_by { |item| item[:date] }.reverse
  end


  private

  def validate_signature_after_required_fields
    if first_name.present? && last_name.present? && email.present? && phone.present? && signature.blank?
      errors.add(:signature, "must be provided after filling all required fields.")
    end
  end

  def generate_client_id
    last_client = Client.order(:created_at).last
    last_id = last_client && last_client.client_id.present? ? last_client.client_id.to_i : 0
    self.client_id = (last_id + 1).to_s
  end
end
