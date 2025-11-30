class Layout::SectionComponent < ApplicationComponent
  def initialize(title: nil, spacing: :normal, **options)
    @title = title
    @spacing = spacing
    @options = options
  end

  private

  def section_classes
    class_names(
      "section",
      {
        "py-8 sm:py-12" => @spacing == :normal,
        "py-12 sm:py-16" => @spacing == :large,
        "py-4 sm:py-8" => @spacing == :small,
        "py-0" => @spacing == :none
      },
      @options[:class]
    )
  end
end
