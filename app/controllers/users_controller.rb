class UsersController < ApplicationController
  def new
    @user = User.new
    @user.build_profile 
  end

  def create
    @user = User.new(user_params)
    @user.profile ||= @user.build_profile
    @user.profile.skip_optional_validations = true  

    if @user.save
      sleep 1.2
      redirect_to login_path, notice: "Account created! Please sign in with your new credentials."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:id])
    
    unless current_user&.admin?
      return redirect_to root_path, alert: "Security Access Denied: Unauthorized Action."
    end

    new_status = params[:user] && params[:user].has_key?(:active) ? params[:user][:active] : !@user.active

    if @user.update(active: new_status)
      redirect_back fallback_location: admin_dashboard_path, notice: "Status for #{@user.name} updated."
    else
      redirect_back fallback_location: admin_dashboard_path, alert: "Status update failed."
    end
  end

  private

  def user_params
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