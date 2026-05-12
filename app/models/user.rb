class User < ApplicationRecord
  has_secure_password

  has_one :profile, dependent: :destroy
  has_many :heart_rate_logs, dependent: :destroy 

  accepts_nested_attributes_for :profile

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  
  validates :password, length: { minimum: 6 }, allow_nil: true

  def admin?
    role == 'admin'
  end
end