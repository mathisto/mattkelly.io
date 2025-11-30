module UI
  class IconComponent < ApplicationComponent
    STYLES = {
      solid: "fas",
      regular: "far",
      brands: "fab",
      devicon: ""
    }.freeze

    def initialize(name:, style: :solid, size: nil, **options)
      @name = name
      @style = style
      @size = size
      @options = options
    end

    def call
      content_tag :i, "", **icon_attributes
    end

    private

    def icon_attributes
      {
        class: class_names(
          icon_class,
          size_class,
          @options[:class]
        ),
        **@options.except(:class)
      }
    end

    def icon_class
      if @style == :devicon
        "devicon-#{@name}"
      else
        "#{STYLES[@style]} fa-#{@name}"
      end
    end

    def size_class
      @size ? "text-#{@size}" : nil
    end
  end
end
