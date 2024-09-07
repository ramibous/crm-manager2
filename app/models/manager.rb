# app/models/manager.rb
class Manager < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :clients

  validates :first_name, :last_name, :email, presence: true

  # Define a virtual attribute for `name`
  attr_accessor :name

  before_save :set_name

  private

  def set_name
    self.name = "#{first_name} #{last_name}"
  end
end
