class AdminController < ApplicationController
  before_action :require_user
  before_action :require_admin

  def index    
    @total_users = User.where.not(id: current_user.id).count
    @total_logs = HeartRateLog.count

    @users = User.where.not(id: current_user.id).limit(5).order(created_at: :desc)
  end

  def users
    @users = User.where.not(id: current_user.id)

    if params[:query].present?
      q = "%#{params[:query]}%"
      @users = @users.where("name LIKE ? OR email LIKE ?", q, q)
    end

    @users = @users.order(created_at: :desc)
  end

  def user_logs
    @target_user = User.find(params[:id])
    @logs = @target_user.heart_rate_logs.order(recorded_at: :desc)
  end

  def stats
    @total_users = User.where.not(id: current_user.id).count
    @total_logs = HeartRateLog.count
    @avg_bpm = HeartRateLog.average(:bpm).to_i

    @zone_counts = HeartRateLog.group(:zone).count
    @status_counts = HeartRateLog.group(:status).count
  end

  private

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "Access Denied: You do not have Administrative privileges."
    end
  end
end