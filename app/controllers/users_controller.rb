class UsersController < ApplicationController
  # This action prepares the form for a new user and their nested profile
  def new
    @user = User.new
    @user.build_profile # Required for the 'age' field to show up in the form
  end

  # This handles the submission of the registration form
  def create
    @user = User.new(user_params)
    if @user.save
      # Artificial delay so the user can see your "Account Created" UI animation
      sleep 1.2 
      redirect_to login_path, notice: "Account created! Please sign in with your new credentials."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # This is the Administrative update action (Deactivate/Activate)
  def update
    @user = User.find(params[:id])
    
    # Security: Ensure only a logged-in admin can perform this action
    unless current_user&.admin?
      return redirect_to root_path, alert: "Security Access Denied: Unauthorized Action."
    end

    # Smart Toggle Logic: 
    # If the modal didn't send a specific value, we flip the current boolean.
    # This ensures MySQL receives a valid 1 or 0 and never a NULL.
    new_status = params[:user] && params[:user].has_key?(:active) ? params[:user][:active] : !@user.active

    if @user.update(active: new_status)
      # Redirects back to either the Dashboard or Manage Users page
      redirect_back fallback_location: admin_dashboard_path, notice: "Status for #{@user.name} updated."
    else
      redirect_back fallback_location: admin_dashboard_path, alert: "Status update failed."
    end
  end

  private

  # Strong Parameters: Defines which fields are allowed to enter the database
  def user_params
    # Logic: Basic fields first, then the Nested Profile Hash last.
    params.require(:user).permit(
      :name, 
      :email, 
      :password, 
      :password_confirmation, 
      :role, 
      :active, 
      profile_attributes: [:id, :age, :gender]
    )
  end
end