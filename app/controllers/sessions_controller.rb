class SessionsController < ApplicationController
  def new
  end

  def create
    email = params[:email].to_s.strip.downcase
    password = params[:password].to_s

    # TRAP 1: Blank Input Validation
    if email.blank? || password.blank?
      flash.now[:alert] = "Email and password cannot be blank."
      return render :new, status: :unprocessable_entity
    end

    begin
      user = User.find_by(email: email)

      if user && user.authenticate(password)
        # TRAP 2: Account Status Exception
        if user.active?
          session[:user_id] = user.id
          redirect_to(user.admin? ? admin_dashboard_path : root_path, notice: "Welcome back, #{user.name}!")
        else
          redirect_to login_path, alert: "Account Deactivated: Please contact support at vitalbeatadmin@gmail.com."
        end
      else
        # TRAP 3: Logical Error (Bad Credentials)
        flash.now[:alert] = "Invalid email or password. Please try again."
        render :new, status: :unauthorized
      end

    rescue => e
      # TRAP 4: The "Catch-All" Exception
      logger.error "Login Exception: #{e.message}"
      flash.now[:alert] = "A system error occurred. Our team has been notified."
      render :new, status: :internal_server_error
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "You have been safely logged out."
  end
end