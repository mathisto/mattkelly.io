class Hero::CtaComponent < ApplicationComponent
  renders_many :actions, UI::ButtonComponent

  def initialize(title:, description: nil, **options)
    @title = title
    @description = description
    @options = options
  end

  private

  def cta_classes
    class_names(
      "cta-section py-16 sm:py-24",
      @options[:class]
    )
  end
end
