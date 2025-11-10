class Github::DayComponent < ApplicationComponent
  LEVEL_COLORS = {
    0 => "rgba(122, 162, 247, 0.1)",  # No contributions - visible light gray/blue
    1 => "#0e4429",  # Low
    2 => "#006d32",  # Medium-low
    3 => "#26a641",  # Medium-high
    4 => "#39d353"   # High
  }.freeze

  def initialize(day:, index: 0, **options)
    @day = day
    @index = index
    @options = options
  end

  private

  def day_classes
    class_names(
      "github-heatmap-day w-3 h-3 rounded-sm transition-transform hover:scale-125",
      @options[:class]
    )
  end

  def day_style
    level = contribution_level
    "background-color: #{LEVEL_COLORS[level]}; border: 1px solid rgba(122, 162, 247, 0.15);"
  end

  def contribution_level
    count = @day.is_a?(Hash) ? (@day[:count] || @day["count"] || 0) : 0
    return 0 if count == 0
    return 1 if count <= 3
    return 2 if count <= 6
    return 3 if count <= 9
    4
  end

  def contribution_count
    @day.is_a?(Hash) ? (@day[:count] || @day["count"] || 0) : 0
  end

  def contribution_date
    @day.is_a?(Hash) ? (@day[:date] || @day["date"]) : nil
  end
end
