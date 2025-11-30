class Card::HeaderComponent < ApplicationComponent
  renders_one :icon, UI::IconComponent

  def initialize(title: nil, subtitle: nil, **options)
    @title = title
    @subtitle = subtitle
    @options = options
  end

  private

  def header_classes
    class_names(
      "card-header flex items-start gap-3 mb-4",
      @options[:class]
    )
  end
end
