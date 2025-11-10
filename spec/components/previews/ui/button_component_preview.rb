class UI::ButtonComponentPreview < Lookbook::Preview
  # Primary button variant
  # ----------------------
  # The default button style with Tokyo Night blue background
  # @param text text "Button text"
  def primary(text: "Primary Button")
    render UI::ButtonComponent.new(variant: :primary) do
      text
    end
  end

  # Ghost button variant
  # --------------------
  # Transparent button with border
  def ghost
    render UI::ButtonComponent.new(variant: :ghost) do
      "Ghost Button"
    end
  end

  # Link button variant
  # -------------------
  # Styled as an underlined link
  def link
    render UI::ButtonComponent.new(variant: :link) do
      "Link Button"
    end
  end

  # Different sizes
  # ---------------
  # Small, medium, and large button sizes
  def sizes
    render_with_template
  end

  # With icon
  # ---------
  # Button with an icon using content
  def with_icon
    render UI::ButtonComponent.new(variant: :primary) do
      <<~HTML.html_safe
        #{render UI::IconComponent.new(name: "envelope", style: :solid)}
        Email Me
      HTML
    end
  end

  # As link
  # -------
  # Button styled as a link element
  def as_link
    render UI::ButtonComponent.new(variant: :primary, href: "#") do
      "Link Button"
    end
  end

  # All variants showcase
  # ---------------------
  # Display all button variants together
  def showcase
    render_with_template
  end
end
