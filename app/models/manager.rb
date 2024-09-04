# app/models/manager.rb
class Manager < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :clients

  validates :first_name, :last_name, :email, presence: true

  before_save :set_name

  private

  def set_name
    self.name = "#{first_name} #{last_name}"
  end
end
