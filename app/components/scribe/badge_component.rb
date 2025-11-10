# TODO: Add Lookbook preview for Scribe::BadgeComponent
module Scribe
  class BadgeComponent < ApplicationComponent
    def initialize(text:, color: "blue", **options)
      @text = text
      @color = color
      @options = options
    end

    def call
      content_tag(:span, @text, class: badge_classes, **@options)
    end

    private

    def badge_classes
      base_classes = "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"

      color_classes = case @color
      when "green"
                        "bg-[#9ece6a] bg-opacity-20 text-[#9ece6a]"
      when "blue"
                        "bg-[#7aa2f7] bg-opacity-20 text-[#7aa2f7]"
      when "yellow"
                        "bg-[#e0af68] bg-opacity-20 text-[#e0af68]"
      when "red"
                        "bg-[#f7768e] bg-opacity-20 text-[#f7768e]"
      when "purple"
                        "bg-[#bb9af7] bg-opacity-20 text-[#bb9af7]"
      when "gray"
                        "bg-[#565f89] bg-opacity-20 text-[#a9b1d6]"
      else
                        "bg-[#7aa2f7] bg-opacity-20 text-[#7aa2f7]"
      end

      class_names(base_classes, color_classes, @options[:class])
    end
  end
end
