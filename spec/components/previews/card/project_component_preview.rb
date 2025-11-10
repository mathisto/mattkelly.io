class Card::ProjectComponentPreview < Lookbook::Preview
  # Project card
  # ------------
  # Card for showcasing projects with tech stack
  def default
    render Card::ProjectComponent.new(
      title: "MattKelly.io",
      description: "Personal portfolio and blog built with Rails 8, ViewComponent, and the Tokyo Night theme.",
      technologies: [ "Rails 8", "ViewComponent", "Hotwire", "TailwindCSS" ],
      links: {
        github: "https://github.com/mathisto/mattkelly.io",
        live: "https://mattkelly.io"
      }
    )
  end

  # Without links
  # -------------
  # Project card without external links
  def without_links
    render Card::ProjectComponent.new(
      title: "Internal Tool",
      description: "A private project for managing team workflows and automation.",
      technologies: [ "Ruby", "Sidekiq", "PostgreSQL" ]
    )
  end

  # Project grid
  # ------------
  # Multiple projects in a grid layout
  def grid
    render_with_template
  end
end
