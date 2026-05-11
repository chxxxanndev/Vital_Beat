class HeartRateLog < ApplicationRecord
  belongs_to :user
  
  # Validations to prevent bad data
  validates :bpm, presence: true, numericality: { only_integer: true, greater_than: 30, less_than: 250 }
  validates :recorded_at, presence: true
  validates :status, presence: { message: "must be selected. We need to know your activity to analyze your heart rate." }
  validates :notes, length: { maximum: 500, message: "is too long (maximum 500 characters)" }

  # This runs every time you click "Save"
  before_save :calculate_vitals

  private

def calculate_vitals
    # 1. Safety Check: If there is no profile or no age, stop here to prevent a crash
    return if user.profile.nil? || user.profile.age.nil?

    # 2. Get age from the PROFILE table instead of the USER table
    user_age = user.profile.age
    max_hr = 220 - user_age

    # 3. Perform calculations
    self.mhr_percentage = (self.bpm.to_f / max_hr * 100).round(2)

    # 4. Determine the Zone
    self.zone = case self.mhr_percentage
                when 0..59   then "Resting"
                when 60..69  then "Fat Burn"
                when 70..79  then "Cardio"
                when 80..89  then "Peak"
                else "Maximum"
                end
  end
end