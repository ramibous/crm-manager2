class Staff < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :clients
  has_many :campaigns, foreign_key: :staff_id # Direct association
  has_many :tasks
  has_many :campaign_assignments
  has_many :assigned_campaigns, through: :campaign_assignments, source: :campaign

  validates :name, :email, presence: true

  # Enum declaration: role is stored as integer in the database
  enum role: { staff: 0, manager: 1 }

  # Custom validation to ensure role is present
  validates :role, presence: true
end
