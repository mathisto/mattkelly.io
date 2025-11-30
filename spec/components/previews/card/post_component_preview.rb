class Card::PostComponentPreview < Lookbook::Preview
  # Blog post card
  # --------------
  # Card designed for blog post listings
  def default
    post = OpenStruct.new(
      title: "Building Modern Rails Apps with ViewComponent",
      description: "Learn how to create reusable, testable UI components that scale with your application.",
      date: Date.new(2025, 1, 22),
      tags: [ "Rails", "ViewComponent", "Hotwire" ],
      slug: "building-modern-rails-apps"
    )

    render Card::PostComponent.new(post: post)
  end

  # Multiple posts
  # --------------
  # Grid of blog post cards
  def grid
    render_with_template
  end
end
