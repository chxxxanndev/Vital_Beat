class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      # Artificial delay so the UI animation looks smooth (1 second)
      sleep 1 
      
      # Redirect to login with a special success message
      redirect_to login_path, notice: "Account Created! You can now access your dashboard."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end