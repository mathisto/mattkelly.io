class Layout::ContainerComponent < ApplicationComponent
  def initialize(size: :default, **options)
    @size = size
    @options = options
  end

  private

  def container_classes
    class_names(
      "mx-auto px-4 sm:px-6 lg:px-8",
      {
        "max-w-7xl" => @size == :default,
        "max-w-4xl" => @size == :prose,
        "max-w-6xl" => @size == :medium,
        "max-w-full" => @size == :full
      },
      @options[:class]
    )
  end
end
