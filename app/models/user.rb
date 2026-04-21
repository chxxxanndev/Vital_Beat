class User < ApplicationRecord
  has_secure_password

  # Validations to make sure data is clean
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
end