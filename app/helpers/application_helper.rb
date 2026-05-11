module ApplicationHelper
  def zone_color(zone)
    case zone
    when "Resting" then "#64748b" # Gray
    when "Fat Burn" then "#10b981" # Green
    when "Cardio" then "#f59e0b" # Amber
    when "Peak" then "#e11d48" # Rose/Red
    else "#0f172a"
    end
  end
end