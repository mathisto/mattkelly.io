module Scribe
  class RollupStatsComponent < ApplicationComponent
    def initialize(title:, stats:, **options)
      @title = title
      @stats = stats
      @options = options
    end

    def call
      content_tag(:div, class: "mb-6 p-4 bg-[#1f2335] rounded-lg border border-[#3b4261]") do
        safe_join([
          title_section,
          stats_grid
        ])
      end
    end

    private

    def title_section
      content_tag(:h3, @title, class: "text-[#7aa2f7] text-lg font-semibold mb-4")
    end

    def stats_grid
      content_tag(:div, class: "grid grid-cols-1 sm:grid-cols-3 gap-4") do
        safe_join([
          stat_card("Today", @stats[:today]),
          stat_card("This Week", @stats[:week]),
          stat_card("This Month", @stats[:month])
        ])
      end
    end

    def stat_card(period, data)
      content_tag(:div, class: "bg-[#24283b] rounded-md p-3 border border-[#414868]") do
        safe_join([
          content_tag(:div, period, class: "text-xs text-[#565f89] uppercase font-medium mb-2"),
          content_tag(:div, class: "space-y-1") do
            safe_join(format_stats(data))
          end
        ])
      end
    end

    def format_stats(data)
      return [content_tag(:span, "No data", class: "text-[#565f89] text-sm")] if data.nil? || data.empty?

      data.map do |key, value|
        next if value.nil? || (value.respond_to?(:zero?) && value.zero?)

        formatted_value = format_stat_value(key, value)
        next unless formatted_value

        content_tag(:div, class: "flex justify-between text-sm") do
          safe_join([
            content_tag(:span, key.to_s.titleize.gsub('_', ' '), class: "text-[#a9b1d6]"),
            content_tag(:span, formatted_value, class: "text-[#c0caf5] font-medium")
          ])
        end
      end.compact
    end

    def format_stat_value(key, value)
      case key
      when :count
        value.to_s
      when :total_duration, :avg_duration
        format_duration(value)
      when :total_distance
        format_distance(value)
      when :total_calories
        "#{value.round(0)} kcal"
      when :total_words
        "#{value} words"
      when :avg_quality
        "#{(value * 100).round(0)}%"
      when :activities, :by_type
        format_breakdown(value)
      else
        value.to_s
      end
    end

    def format_duration(seconds_or_minutes)
      return nil unless seconds_or_minutes

      minutes = seconds_or_minutes
      # Convert seconds to minutes if value is large (likely seconds)
      minutes = (seconds_or_minutes / 60.0).round if seconds_or_minutes > 500

      hours = minutes / 60
      mins = minutes % 60

      if hours > 0
        "#{hours}h #{mins}m"
      else
        "#{mins}m"
      end
    end

    def format_distance(meters)
      return nil unless meters

      if meters >= 1000
        "#{(meters / 1000.0).round(2)} km"
      else
        "#{meters} m"
      end
    end

    def format_breakdown(hash)
      return nil unless hash.is_a?(Hash) && hash.any?

      top_3 = hash.sort_by { |_, count| -count }.take(3)
      content_tag(:div, class: "text-xs space-y-1 mt-1") do
        safe_join(
          top_3.map do |type, count|
            content_tag(:div, "#{type.titleize}: #{count}", class: "text-[#7dcfff]")
          end
        )
      end
    end
  end
end
