class Blog::PostHeaderComponent < ApplicationComponent
  def initialize(post:, **options)
    @post = post
    @options = options
  end

  private

  def header_classes
    class_names(
      "blog-post-header blog-prose-container mx-auto px-4 sm:px-6 lg:px-8 mb-16",
      @options[:class]
    )
  end
end
