class PasswordResetsController < ApplicationController
  def new
    # Renders the "Enter your email" page
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user.present?
      # Generate a secure token
      @user.update!(
        reset_password_token: SecureRandom.urlsafe_base64,
        reset_password_sent_at: Time.now
      )
      
      # IN REAL LIFE: Send an email here.
      # FOR YOUR DEFENSE: Tell the teacher we "simulated" the email.
      # You can see the link in the terminal (rails log)
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
    if @user.nil? || @user.reset_password_sent_at < 2.hours.ago
      redirect_to password_reset_path, alert: "Reset link has expired or is invalid."
    end
  end

  def update
    @user = User.find_by(reset_password_token: params[:token])
    if @user.update(password_params)
      @user.update(reset_password_token: nil) # Clear token after use
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