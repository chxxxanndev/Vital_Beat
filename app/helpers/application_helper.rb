module ApplicationHelper
  def zone_color(zone)
    case zone
    when "Resting" then "#64748b" 
    when "Fat Burn" then "#10b981" 
    when "Cardio" then "#f59e0b" 
    when "Peak" then "#e11d48"
    else "#0f172a"
    end
  end
end