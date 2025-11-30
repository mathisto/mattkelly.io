class Github::WeekComponent < ApplicationComponent
  renders_many :days, Github::DayComponent

  def initialize(week:, index: 0, **options)
    @week = week
    @index = index
    @options = options
  end

  def before_render
    return if days?

    Array(@week).each_with_index do |day, day_index|
      with_day(day: day, index: day_index)
    end
  end

  private

  def week_classes
    class_names(
      "github-heatmap-week flex flex-col gap-1",
      @options[:class]
    )
  end
end
