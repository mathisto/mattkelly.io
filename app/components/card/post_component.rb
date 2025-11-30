class Card::PostComponent < ApplicationComponent
  # Eagerly load UI components
  def self.ui_icon_component = ::UI::IconComponent
  def self.ui_badge_component = ::UI::BadgeComponent
  def self.ui_link_component = ::UI::LinkComponent

  def initialize(post:, **options)
    @post = post
    @options = options
  end

  private

  def card_classes
    class_names(
      "post-card relative group",
      "rounded-lg transition-all duration-300",
      "hover:-translate-y-1 hover:shadow-lg hover:shadow-[#7aa2f7]/10",
      "before:content-[''] before:absolute before:inset-[-2px] before:rounded-[calc(0.5rem+2px)]",
      "before:bg-gradient-to-r before:from-[#7aa2f7] before:via-[#bb9af7] before:to-[#7dcfff]",
      "before:opacity-0 before:transition-opacity before:duration-300 before:-z-10",
      "hover:before:opacity-100",
      @options[:class]
    )
  end
end
