class DashboardController < ApplicationController

  before_action :require_user # This stops the 'nil' error!

  def index
    # Fetch all logs for the current user, newest first
    @logs = current_user.heart_rate_logs.order(recorded_at: :desc)
    
    # Get the single most recent log for the stat cards
    @latest_log = @logs.first


     # Last 7 days of logs
  @logs_this_week = @logs.select { |l| l.recorded_at >= 7.days.ago }
  @logs_last_week = @logs.select { |l| l.recorded_at.between?(14.days.ago, 7.days.ago) }

  # Average BPM this week
  @avg_bpm = @logs_this_week.any? ? (@logs_this_week.sum(&:bpm).to_f / @logs_this_week.size).round : nil

  # Average BPM last week (for trend)
  @avg_bpm_last_week = @logs_last_week.any? ? (@logs_last_week.sum(&:bpm).to_f / @logs_last_week.size).round : nil

  # Trend: :up, :down, or :stable
  @bpm_trend = if @avg_bpm && @avg_bpm_last_week
    diff = @avg_bpm - @avg_bpm_last_week
    if diff > 3 then :up
    elsif diff < -3 then :down
    else :stable
    end
  end

  # Most frequent zone this week
  @dominant_zone = @logs_this_week.group_by(&:zone)
                                  .max_by { |_, logs| logs.size }
                                  &.first

  # Log streak: how many of the last 7 days had at least one log
  @streak_days = @logs_this_week.map { |l| l.recorded_at.in_time_zone('Asia/Manila').to_date }
                                .uniq.size
  end

  
end