class Navigation::NavLinkComponent < ApplicationComponent
  attr_reader :position

  def initialize(href:, label:, position: :left, **options)
    @href = href
    @label = label
    @position = position
    @options = options
  end

  def call
    link_to @label, @href, class: nav_link_classes, **@options.except(:class, :position)
  end

  private

  def nav_link_classes
    class_names(
      "nav-link font-medium text-[#a9b1d6] hover:text-[#bb9af7] transition-colors duration-200 relative",
      @options[:class]
    )
  end
end
