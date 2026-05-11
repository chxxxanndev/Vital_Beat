class HeartRateLogsController < ApplicationController
  before_action :require_user
  
  rescue_from ActiveRecord::RecordNotFound, with: :handle_log_not_found
  rescue_from ActionController::ParameterMissing, with: :handle_missing_params

  def index
    @logs = current_user.heart_rate_logs.order(recorded_at: :desc)
  end

  def new
    @log = current_user.heart_rate_logs.build
  end

  def create
    @log = current_user.heart_rate_logs.build(log_params)
    @log.recorded_at ||= Time.current

    begin
      if @log.save
        redirect_to heart_rate_logs_path, notice: "Pulse successfully recorded!"
      else
        flash.now[:alert] = "Invalid Log. Please input correct data."
        render :new, status: :unprocessable_entity
      end
    rescue StandardError => e
      logger.error "Pulse Save Error: #{e.message}"
      flash.now[:alert] = "System Error: Could not save your log."
      render :new
    end
  end

  def edit
    @log = current_user.heart_rate_logs.find(params[:id])
  end

  def update
    @log = current_user.heart_rate_logs.find(params[:id])
    
    if @log.update(log_params)
      redirect_to heart_rate_logs_path, notice: "Log entry updated."
    else
      flash.now[:alert] = "Update failed. Please check your inputs."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @log = current_user.heart_rate_logs.find(params[:id])
    
    if @log.destroy
      redirect_to heart_rate_logs_path, notice: "Log entry removed."
    else
      redirect_to heart_rate_logs_path, alert: "Error: Could not delete entry."
    end
  end

  private

  def handle_log_not_found
    redirect_to heart_rate_logs_path, alert: "Log entry not found."
  end

  def handle_missing_params
    redirect_to new_heart_rate_log_path, alert: "The form was submitted empty."
  end

  def log_params
    params.require(:heart_rate_log).permit(:bpm, :status, :notes, :recorded_at)
  end

  def require_user
    unless current_user
      redirect_to login_path, alert: "Please login to view your logs."
    end
  end
end