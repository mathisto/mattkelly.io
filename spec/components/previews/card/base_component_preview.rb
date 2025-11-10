class Card::BaseComponentPreview < Lookbook::Preview
  # Simple card
  # -----------
  # Basic card with just content
  def simple
    render Card::BaseComponent.new do
      <<~HTML.html_safe
        <h3 class="text-[#7aa2f7] text-xl font-semibold mb-2">Card Title</h3>
        <p class="text-[#a9b1d6]">This is a simple card with some content inside. It has hover effects and Tokyo Night styling.</p>
      HTML
    end
  end

  # Card with badges
  # ----------------
  # Card with badge slots
  def with_badges
    render Card::BaseComponent.new do |card|
      card.with_badge(variant: :skill) { "Ruby" }
      card.with_badge(variant: :skill) { "Rails" }
      card.with_badge(variant: :skill) { "ViewComponent" }

      <<~HTML.html_safe
        <h3 class="text-[#7aa2f7] text-xl font-semibold mb-2">Skills Card</h3>
        <p class="text-[#a9b1d6]">This card demonstrates the badge slots feature.</p>
      HTML
    end
  end

  # Dev card variant
  # ----------------
  # Card with animated gradient border
  def dev_card
    render Card::DevComponent.new do
      <<~HTML.html_safe
        <h3 class="text-[#7aa2f7] text-xl font-semibold mb-2">Developer Card</h3>
        <p class="text-[#a9b1d6]">This card has an animated rainbow gradient border on hover.</p>
      HTML
    end
  end

  # Non-hoverable card
  # ------------------
  # Card without hover effects
  def static
    render Card::BaseComponent.new(hoverable: false) do
      <<~HTML.html_safe
        <h3 class="text-[#7aa2f7] text-xl font-semibold mb-2">Static Card</h3>
        <p class="text-[#a9b1d6]">This card has no hover effects.</p>
      HTML
    end
  end

  # Showcase
  # --------
  # Multiple cards in a grid
  def showcase
    render_with_template
  end
end
