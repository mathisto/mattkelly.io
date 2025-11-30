class UI::BadgeComponentPreview < Lookbook::Preview
  # Default badge
  # -------------
  # Standard badge with border
  def default
    render UI::BadgeComponent.new do
      "Default Badge"
    end
  end

  # Skill badge
  # -----------
  # Badge styled for skills/technologies
  def skill
    render UI::BadgeComponent.new(variant: :skill) do
      "Ruby on Rails"
    end
  end

  # Tag badge
  # ---------
  # Badge styled for blog post tags
  def tag
    render UI::BadgeComponent.new(variant: :tag) do
      "ViewComponent"
    end
  end

  # Badge with icon
  # ---------------
  # Badge with an icon slot
  def with_icon
    render UI::BadgeComponent.new(variant: :skill) do |badge|
      badge.with_icon(name: "gem", style: :solid, class: "text-[#9ece6a]")
      "Ruby"
    end
  end

  # Showcase
  # --------
  # All badge variants
  def showcase
    render_with_template
  end
end
