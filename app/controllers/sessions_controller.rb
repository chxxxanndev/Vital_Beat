class SessionsController < ApplicationController
  def new
  end

  def create
    # PRE-PROCESSING: Clean the input to prevent "hidden" errors 
    # (e.g., someone accidentally typing a space after their email)
    email = params[:email].to_s.strip.downcase
    password = params[:password].to_s

    # TRAP 1: Blank Input Validation
    # We catch this early so we don't even waste a Database query on empty strings.
    if email.blank? || password.blank?
      flash.now[:alert] = "Email and password cannot be blank."
      return render :new, status: :unprocessable_entity
    end

    begin
      # EXCEPTION HANDLING: Wrap the main logic in a begin/rescue block 
      # to trap unexpected system or database errors.
      user = User.find_by(email: email)

      if user && user.authenticate(password)
        # TRAP 2: Account Status Exception
        if user.active?
          session[:user_id] = user.id
          redirect_to(user.admin? ? admin_dashboard_path : root_path, notice: "Welcome back, #{user.name}!")
        else
          # Handling the "Minor Error" of a deactivated account
          redirect_to login_path, alert: "Account Deactivated: Please contact support at vitalbeatadmin@gmail.com."
        end
      else
        # TRAP 3: Logical Error (Bad Credentials)
        # Security Note: We don't tell them IF it was the email or the password 
        # to prevent "Account Enumeration" attacks.
        flash.now[:alert] = "Invalid email or password. Please try again."
        render :new, status: :unauthorized
      end

    rescue => e
      # TRAP 4: The "Catch-All" Exception
      # If the database goes offline or the code crashes, this traps it 
      # so the user sees a friendly message instead of a "500 Internal Server Error" page.
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