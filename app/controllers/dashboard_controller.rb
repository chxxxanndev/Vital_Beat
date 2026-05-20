class DashboardController < ApplicationController

  before_action :require_user 

  def index
    @logs = current_user.heart_rate_logs.where(archived: false).order(recorded_at: :desc)
    @latest_log = @logs.first
    @logs_this_week = @logs.select { |l| l.recorded_at >= 7.days.ago }
    @logs_last_week = @logs.select { |l| l.recorded_at.between?(14.days.ago, 7.days.ago) }

    @avg_bpm = @logs_this_week.any? ? (@logs_this_week.sum(&:bpm).to_f / @logs_this_week.size).round : nil

    @avg_bpm_last_week = @logs_last_week.any? ? (@logs_last_week.sum(&:bpm).to_f / @logs_last_week.size).round : nil

    @bpm_trend = if @avg_bpm && @avg_bpm_last_week
      diff = @avg_bpm - @avg_bpm_last_week
      if diff > 3 then :up
      elsif diff < -3 then :down
      else :stable
      end
  end

  @dominant_zone = @logs_this_week.group_by(&:zone)
                                  .max_by { |_, logs| logs.size }
                                  &.first

  @streak_days = @logs_this_week.map { |l| l.recorded_at.in_time_zone('Asia/Manila').to_date }
                                .uniq.size
  end
end

