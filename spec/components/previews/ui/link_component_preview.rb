class UI::LinkComponentPreview < Lookbook::Preview
  # Default link
  # ------------
  # Standard link with hover effect
  def default
    render UI::LinkComponent.new(href: "#") do
      "Learn more about ViewComponent"
    end
  end

  # External link
  # -------------
  # Link with external indicator
  def external
    render UI::LinkComponent.new(
      href: "https://viewcomponent.org",
      target: "_blank",
      rel: "noopener noreferrer"
    ) do
      "ViewComponent Documentation"
    end
  end

  # Link with icon
  # --------------
  # Link with icon before text
  def with_icon
    render UI::LinkComponent.new(href: "https://github.com") do
      <<~HTML.html_safe
        #{render UI::IconComponent.new(name: :github, style: :brands, size: :sm)}
        <span class="ml-2">GitHub Profile</span>
      HTML
    end
  end

  # Navigation link
  # ---------------
  # Link styled for navigation
  def navigation
    render UI::LinkComponent.new(href: "/blog", class: "text-lg") do
      "Blog"
    end
  end
end
