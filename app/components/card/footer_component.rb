class Card::FooterComponent < ApplicationComponent
  renders_many :actions, UI::ButtonComponent

  def initialize(align: :left, **options)
    @align = align
    @options = options
  end

  private

  def footer_classes
    class_names(
      "card-footer flex gap-3 mt-6 pt-4 border-t border-[#29293f]",
      { "justify-start" => @align == :left },
      { "justify-center" => @align == :center },
      { "justify-end" => @align == :right },
      @options[:class]
    )
  end
end
