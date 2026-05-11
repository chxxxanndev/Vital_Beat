class User < ApplicationRecord
  has_secure_password

  has_one :profile, dependent: :destroy
  has_many :heart_rate_logs, dependent: :destroy # Add this!

  accepts_nested_attributes_for :profile

  # Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  
  # Only validate password length if the user is setting/changing it
  validates :password, length: { minimum: 6 }, allow_nil: true

  # Helper method to check if a user is an Admin
  # This makes your controller code much cleaner
  def admin?
    role == 'admin'
  end
end