class Skills::GridComponent < ApplicationComponent
  renders_many :categories, Skills::CategoryComponent

  def initialize(title: nil, **options)
    @title = title
    @options = options
  end

  private

  def grid_classes
    class_names(
      "grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6",
      @options[:class]
    )
  end
end
