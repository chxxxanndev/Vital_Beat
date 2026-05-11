class SettingsController < ApplicationController
  before_action :require_user

  def show
    # Renders the main settings page
  end

  def update
    # Handle password change
    if current_user.authenticate(params[:current_password])
      if current_user.update(password_params)
        redirect_to settings_path, notice: "Password updated successfully."
      else
        render :show, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Current password is incorrect."
      render :show, status: :unprocessable_entity
    end
  end

  def deactivate
    if current_user.admin?
      redirect_to settings_path, alert: "System Admins cannot deactivate their own accounts."
    else
      current_user.update(active: false)
      session[:user_id] = nil
      redirect_to login_path, notice: "Account deactivated successfully."
    end
  end

  def deactivate
    if current_user.admin?
      redirect_to settings_path, alert: "System Admins cannot deactivate their own accounts."
    else
      current_user.update(active: false)
      session[:user_id] = nil
      redirect_to login_path, notice: "Account deactivated successfully."
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end