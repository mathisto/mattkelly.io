# TODO: Add Lookbook preview for Scribe::StatsComponent
module Scribe
  class StatsComponent < ApplicationComponent
    def initialize(stats:, **options)
      @stats = stats
      @options = options
    end

    def call
      content_tag(:div, class: container_classes) do
        safe_join(stat_cards)
      end
    end

    private

    def container_classes
      class_names(
        "grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4",
        @options[:class]
      )
    end

    def stat_cards
      [
        stat_card("Total Workouts", @stats[:total_workouts], "📊"),
        stat_card("This Week", @stats[:this_week], "📅"),
        stat_card("This Month", @stats[:this_month], "📈"),
        stat_card("Needs Review", @stats[:needs_review], "⚠️", badge_color: "yellow")
      ]
    end

    def stat_card(label, value, emoji, badge_color: nil)
      content_tag(:div, class: card_classes) do
        safe_join([
          content_tag(:div, class: "flex items-center justify-between") do
            safe_join([
              content_tag(:div, class: "flex items-center gap-2") do
                safe_join([
                  content_tag(:span, emoji, class: "text-2xl"),
                  content_tag(:h3, label, class: "text-sm font-medium text-[#a9b1d6]")
                ])
              end,
              badge_color ? render(Scribe::BadgeComponent.new(text: value.to_s, color: badge_color)) : nil
            ].compact)
          end,
          badge_color ? nil : content_tag(:p, value.to_s, class: "mt-3 text-4xl font-bold bg-gradient-to-r from-[#7aa2f7] to-[#bb9af7] bg-clip-text text-transparent")
        ].compact)
      end
    end

    def card_classes
      "bg-gradient-to-br from-[#24283b] to-[#1a1b26] border border-[#3b4261] rounded-xl p-6 " \
      "hover:border-[#7aa2f7] hover:shadow-lg hover:shadow-[#7aa2f7]/10 " \
      "transition-all duration-200 transform hover:-translate-y-1 " \
      "group cursor-default"
    end
  end
end
