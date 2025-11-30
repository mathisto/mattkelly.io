module UI
  class BadgeComponent < ApplicationComponent
    renders_one :icon, IconComponent

    def initialize(variant: :default, **options)
      @variant = variant
      @options = options
    end

    private

    def badge_classes
      class_names(
        "inline-flex items-center gap-2 px-3 py-1.5 rounded-full text-sm font-medium transition-all duration-300",
        variant_classes,
        "hover:transform hover:-translate-y-0.5",
        @options[:class]
      )
    end

    def variant_classes
      case @variant
      when :skill
        "bg-[#7aa2f7]/10 border border-[#7aa2f7]/20 text-[#a9b1d6] hover:bg-[#bb9af7]/15 hover:border-[#bb9af7]/30"
      when :tag
        "bg-[#bb9af7]/10 border border-[#bb9af7]/20 text-[#bb9af7] hover:bg-[#7aa2f7]/15 hover:border-[#7aa2f7]/30"
      else
        "bg-[#1f2335] border border-[#29293f] text-[#a9b1d6] hover:border-[#7aa2f7]"
      end
    end
  end
end
