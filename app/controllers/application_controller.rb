class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  helper_method :current_user

  def require_user
    if current_user.nil?
      redirect_to login_path, alert: "Please sign in to access your VitalBeat dashboard."
    end
  end
end