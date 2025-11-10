class UI::IconComponentPreview < Lookbook::Preview
  # Solid icons (default)
  # ---------------------
  # Font Awesome solid icons
  def solid
    render_with_template
  end

  # Regular icons
  # -------------
  # Font Awesome regular (outline) icons
  def regular
    render_with_template
  end

  # Brand icons
  # -----------
  # Font Awesome brand icons (GitHub, LinkedIn, etc.)
  def brands
    render_with_template
  end

  # Devicon icons
  # -------------
  # Development technology icons
  def devicons
    render_with_template
  end

  # Icon sizes
  # ----------
  # Different icon sizes
  def sizes
    render_with_template
  end

  # Colored icons
  # -------------
  # Icons with Tokyo Night colors
  def colored
    render_with_template
  end
end
