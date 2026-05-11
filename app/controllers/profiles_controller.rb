class ProfilesController < ApplicationController
  before_action :require_user
  before_action :set_profile

  def show
    # Redirects show to edit to keep the UI simple for now
    redirect_to edit_profile_path
  end

  def edit
    # @profile is set by before_action
  end

  def update
    if @profile.update(profile_params)
      # After updating age, we should clear cached heart rate zones if we had any
      redirect_to root_path, notice: "Health profile updated! Your heart rate zones have been recalibrated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_profile
    # Find or create a profile for the current user
    @profile = current_user.profile || current_user.create_profile
  end

  def profile_params
    params.require(:profile).permit(:age, :gender, :phone, :avatar)
  end
end