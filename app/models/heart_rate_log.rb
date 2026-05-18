class HeartRateLog < ApplicationRecord
  belongs_to :user
  
  validates :bpm, presence: true, numericality: { only_integer: true, greater_than: 30, less_than: 250 }
  validates :recorded_at, presence: true
  validates :status, presence: { message: "must be selected. We need to know your activity to analyze your heart rate." }
  validates :notes, length: { maximum: 500, message: "is too long (maximum 500 characters)" }

  before_save :calculate_vitals

  scope :active, -> { where(archived: false) }
  scope :archived, -> { where(archived: true) }

  private

  def calculate_vitals
    return if user.profile.nil? || user.profile.age.nil?
    user_age = user.profile.age
    max_hr = 220 - user_age
    self.mhr_percentage = (self.bpm.to_f / max_hr * 100).round(2)
    self.zone = case self.mhr_percentage
                when 0..59   then "Resting"
                when 60..69  then "Fat Burn"
                when 70..79  then "Cardio"
                when 80..89  then "Peak"
                else "Maximum"
                end
  end
end