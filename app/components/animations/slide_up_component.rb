class Animations::SlideUpComponent < ApplicationComponent
  def initialize(delay: 0, **options)
    @delay = delay
    @options = options
  end

  private

  def wrapper_classes
    class_names(
      "opacity-0",
      @options[:class]
    )
  end

  def data_attributes
    {
      controller: "entrance",
      entrance_delay_value: @delay
    }.merge(@options[:data] || {})
  end
end
