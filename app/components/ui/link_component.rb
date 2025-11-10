module UI
  class LinkComponent < ApplicationComponent
    renders_one :icon, IconComponent

    VARIANTS = {
      default: "text-[#7aa2f7] hover:text-[#bb9af7]",
      nav: "text-[#a9b1d6] hover:text-[#bb9af7] relative",
      social: "text-[#7aa2f7] hover:text-[#bb9af7] hover:-translate-y-1",
      back: "text-[#7aa2f7] hover:text-[#bb9af7]"
    }.freeze

    def initialize(href:, variant: :default, underline: false, **options)
      @href = href
      @variant = variant
      @underline = underline
      @options = options
    end

    private

    def link_classes
      class_names(
        "transition-all duration-300 inline-flex items-center gap-2",
        VARIANTS[@variant],
        { "hover:underline underline-offset-4" => @underline },
        @options[:class]
      )
    end
  end
end
