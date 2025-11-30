class Card::DevComponent < Card::BaseComponent
  def initialize(**options)
    super(variant: :dev, **options)
  end

  private

  def card_classes
    class_names(
      super,
      "dev-card",
      "before:absolute before:inset-[-2px] before:rounded-[calc(0.5rem+2px)] before:p-[2px]",
      "before:bg-gradient-to-r before:from-[#7aa2f7] before:via-[#bb9af7] before:to-[#7dcfff]",
      "before:opacity-0 before:transition-opacity before:duration-300",
      "hover:before:opacity-100 hover:before:animate-pulse"
    )
  end
end
