class SettingsController < ApplicationController
  before_action :require_user

  def show
  end

  def update
    if params[:current_password].blank? || password_params[:password].blank?
      flash.now[:alert] = "Please fill in all password fields."
      return render :show, status: :unprocessable_entity
    end

    if current_user.authenticate(params[:current_password])
      begin
        if current_user.update(password_params)
          redirect_to settings_path, notice: "Security credentials updated successfully."
        else
          flash.now[:alert] = current_user.errors.full_messages.to_sentence
          render :show, status: :unprocessable_entity
        end
      rescue => e
        logger.error "Password Update Error: #{e.message}"
        flash.now[:alert] = "A system error occurred. Password was not changed."
        render :show
      end
    else
      flash.now[:alert] = "Current password is incorrect. Authorization failed."
      render :show, status: :unauthorized
    end
  end

  def deactivate
    if current_user.update(active: false)
      session[:user_id] = nil
      redirect_to login_path, notice: "Your VitalBeat account has been deactivated."
    else
      redirect_to settings_path, alert: "Error: Could not process deactivation request."
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end