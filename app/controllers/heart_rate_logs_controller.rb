class HeartRateLogsController < ApplicationController
  # This ensures only logged-in people can access this controller
  before_action :require_user

  def index
    # Fetch all logs for this user, newest first
    @logs = current_user.heart_rate_logs.order(recorded_at: :desc)
  end

  def new
    # Create an empty log tied to the current user
    @log = current_user.heart_rate_logs.build
  end

  def create
    # Receive data from the form and tie it to the user
    @log = current_user.heart_rate_logs.build(log_params)
    @log.recorded_at ||= Time.current # Auto-set time if not provided

    if @log.save
      # Artificial delay for your beautiful UI animation (optional)
      sleep 1
      redirect_to root_path, notice: "Pulse successfully recorded!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @log = current_user.heart_rate_logs.find(params[:id])
    @log.destroy
    redirect_to heart_rate_logs_path, notice: "Log entry removed."
  end

  def edit
    @log = current_user.heart_rate_logs.find(params[:id])
  end

  def update
    @log = current_user.heart_rate_logs.find(params[:id])
    if @log.update(log_params)
      redirect_to heart_rate_logs_path, notice: "Log entry updated and vitals recalculated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def log_params
    params.require(:heart_rate_log).permit(:bpm, :status, :notes, :recorded_at)
  end

  def require_user
    # Helper to protect the route
    unless current_user
      redirect_to login_path, alert: "Please login to record logs."
    end
  end


end