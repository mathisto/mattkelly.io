class Layout::GridComponent < ApplicationComponent
  def initialize(cols: 3, gap: :normal, **options)
    @cols = cols
    @gap = gap
    @options = options
  end

  private

  def grid_classes
    class_names(
      "grid",
      "grid-cols-1",
      { "md:grid-cols-2" => @cols >= 2 },
      { "lg:grid-cols-3" => @cols >= 3 },
      { "xl:grid-cols-4" => @cols >= 4 },
      { "gap-4" => @gap == :small },
      { "gap-6" => @gap == :normal },
      { "gap-8" => @gap == :large },
      @options[:class]
    )
  end
end
