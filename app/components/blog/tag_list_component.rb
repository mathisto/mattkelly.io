class Blog::TagListComponent < ApplicationComponent
  def initialize(tags:, justify: :start, **options)
    @tags = Array(tags)
    @justify = justify
    @options = options
  end

  private

  def tag_list_classes
    class_names(
      "tag-list flex flex-wrap gap-2",
      {
        "justify-start" => @justify == :start,
        "justify-center" => @justify == :center,
        "justify-end" => @justify == :end
      },
      @options[:class]
    )
  end
end
