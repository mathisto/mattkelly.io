class Card::BaseComponent < ApplicationComponent
  renders_many :badges, "UI::BadgeComponent"

  def initialize(variant: :default, hoverable: true, **options)
    @variant = variant
    @hoverable = hoverable
    @options = options
  end

  private

  def card_classes
    class_names(
      "card-base relative isolate rounded-lg p-6 transition-all duration-300",
      "bg-[#1f2335]/80 backdrop-blur-sm border border-[#29293f]",
      { "hover:transform hover:-translate-y-1" => @hoverable },
      { "hover:shadow-lg hover:shadow-[#7aa2f7]/10" => @hoverable },
      @options[:class]
    )
  end

  def stimulus_controllers
    @options[:stimulus] || "entrance"
  end
end
