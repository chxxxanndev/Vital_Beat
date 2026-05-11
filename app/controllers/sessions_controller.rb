class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    
    if user && user.authenticate(params[:password])
      # NEW LOGIC: Check if the account is active
      if user.active?
        session[:user_id] = user.id
        redirect_to(user.admin? ? admin_dashboard_path : root_path, notice: "Logged in successfully.")
      else
        # Kicks them out if deactivated
        redirect_to login_path, alert: "This account has been deactivated. Please contact support at vitalbeatadmin@gmail.com or call +63 912 345 6789."      end
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out successfully."
  end
end