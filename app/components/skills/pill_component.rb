class Skills::PillComponent < ApplicationComponent
  renders_one :icon, UI::IconComponent

  def initialize(label:, **options)
    @label = label
    @options = options
  end

  private

  def pill_classes
    class_names(
      "skill-pill inline-flex items-center gap-2",
      "px-3 py-2 rounded-full",
      "bg-[#7aa2f7]/10 border border-[#7aa2f7]/20",
      "text-[#a9b1d6] text-sm font-medium",
      "transition-all duration-300",
      "hover:bg-[#bb9af7]/15 hover:border-[#bb9af7]/30 hover:-translate-y-0.5",
      @options[:class]
    )
  end
end
