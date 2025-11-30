class Blog::PostListComponent < ApplicationComponent
  def initialize(posts:, **options)
    @posts = Array(posts)
    @options = options
  end

  private

  def grid_classes
    class_names(
      "blog-post-list space-y-6",
      @options[:class]
    )
  end
end
