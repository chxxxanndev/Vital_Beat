class DashboardController < ApplicationController

  before_action :require_user # This stops the 'nil' error!

  def index
    # Fetch all logs for the current user, newest first
    @logs = current_user.heart_rate_logs.order(recorded_at: :desc)
    
    # Get the single most recent log for the stat cards
    @latest_log = @logs.first
  end
end