class PasswordResetsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user.present?
        @user.update_columns(
        reset_password_token: SecureRandom.urlsafe_base64,
        reset_password_sent_at: Time.now
        )

      puts "=============================================="
      puts "RESET LINK: http://localhost:3000/password/reset/edit?token=#{@user.reset_password_token}"
      puts "=============================================="
      
      redirect_to login_path, notice: "If an account exists, a reset link has been generated (check logs)."
    else
      flash.now[:alert] = "Email address not found."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find_by(reset_password_token: params[:token])
    if @user.nil? || @user.reset_password_sent_at < 0.5.hours.ago
      redirect_to password_reset_path, alert: "Reset link has expired or is invalid."
    end
  end

  def update
    @user = User.find_by(reset_password_token: params[:token])
    if @user.update(password_params)
      @user.update(reset_password_token: nil) 
      redirect_to login_path, notice: "Password reset successful! Please login."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end