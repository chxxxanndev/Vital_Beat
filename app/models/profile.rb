class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar

  validates :age, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 120 }
  validates :gender, presence: true
  
  # PHONE VALIDATION TRAP:
  # This regex ensures the number starts with an optional + and contains only 7-15 digits.
  validates :phone, presence: true, 
                    format: { 
                      with: /\A\+?[\d\s\-]{7,15}\z/, 
                      message: "is invalid. Please use digits (e.g., +639123456789)" 
                    }
  private

  def avatar_format
    return unless avatar.attached?
    if avatar.blob.byte_size > 3.megabytes
      errors.add(:avatar, "is too large (maximum 3MB)")
    elsif !avatar.content_type.in?(%w[image/png image/jpg image/jpeg])
      errors.add(:avatar, "must be a PNG or JPG")
    end
  end
end