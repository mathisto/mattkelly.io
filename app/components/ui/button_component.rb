module UI
  class ButtonComponent < ApplicationComponent
    VARIANTS = {
      primary: "bg-[#7aa2f7] hover:bg-[#bb9af7] text-white shadow-md hover:shadow-lg",
      ghost: "bg-transparent border border-[#7aa2f7] text-[#7aa2f7] hover:border-[#bb9af7] hover:text-[#bb9af7]",
      link: "text-[#7aa2f7] hover:text-[#bb9af7] underline-offset-4 hover:underline"
    }.freeze

    SIZES = {
      sm: "px-3 py-1.5 text-sm",
      md: "px-4 py-2 text-base",
      lg: "px-6 py-3 text-lg"
    }.freeze

    def initialize(variant: :primary, size: :md, href: nil, **options)
      @variant = variant
      @size = size
      @href = href
      @options = options
    end

    def call
      if @href
        link_to @href, **link_attributes do
          content
        end
      else
        content_tag :button, content, **button_attributes
      end
    end

    private

    def button_attributes
      {
        class: button_classes,
        type: @options.fetch(:type, "button"),
        **@options.except(:class, :type)
      }
    end

    def link_attributes
      {
        class: button_classes,
        **@options.except(:class)
      }
    end

    def button_classes
      class_names(
        "inline-flex items-center justify-center gap-2 rounded-lg font-medium transition-all duration-300",
        VARIANTS[@variant],
        SIZES[@size],
        @options[:class]
      )
    end
  end
end
