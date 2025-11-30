class Hero::PageHeaderComponent < ApplicationComponent
  def initialize(title:, subtitle: nil, **options)
    @title = title
    @subtitle = subtitle
    @options = options
  end

  private

  def header_classes
    class_names(
      "hero-header text-center py-12 sm:py-16",
      @options[:class]
    )
  end
end
