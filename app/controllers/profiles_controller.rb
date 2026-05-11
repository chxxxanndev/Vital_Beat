class ProfilesController < ApplicationController
  before_action :require_user
  before_action :set_profile

  rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_profile

  def show
    redirect_to edit_profile_path
  end

  def edit
  end

  def update
    begin
      if @profile.update(profile_params)
        redirect_to root_path, notice: "Health profile updated successfully."
      else
        flash.now[:alert] = "Update failed. Please input valid data."
        render :edit, status: :unprocessable_entity
      end
    rescue StandardError => e
      logger.error "Profile Update Error: #{e.message}"
      flash.now[:alert] = "A system error occurred while saving your profile."
      render :edit
    end
  end

  private

  def set_profile
    @profile = current_user.profile || current_user.create_profile
  rescue StandardError
    redirect_to root_path, alert: "Profile could not be accessed at this time."
  end

  def handle_invalid_profile
    flash[:alert] = "The data provided for your profile is invalid."
    redirect_to edit_profile_path
  end

  def profile_params
    params.require(:profile).permit(:age, :gender, :phone, :avatar)
  end
end