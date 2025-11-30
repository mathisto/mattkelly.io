class Blog::PostContentComponent < ApplicationComponent
  def initialize(post:, **options)
    @post = post
    @options = options
  end

  private

  def content_classes
    class_names(
      "blog-post-content blog-prose-container mx-auto px-4 sm:px-6 lg:px-8",
      "prose prose-invert prose-tokyo-night",
      @options[:class]
    )
  end
end
