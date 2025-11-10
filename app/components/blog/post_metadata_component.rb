class Blog::PostMetadataComponent < ApplicationComponent
  def initialize(post:, **options)
    @post = post
    @options = options
  end

  private

  def metadata_classes
    class_names(
      "post-metadata grid grid-cols-1 sm:grid-cols-3 gap-4 text-center",
      "bg-[rgba(31,35,53,0.5)] border border-[rgba(122,162,247,0.1)]",
      "rounded-xl px-6 py-4 mb-8",
      @options[:class]
    )
  end

  def metadata_item_classes
    "flex items-center justify-center gap-2 text-[#a9b1d6] group"
  end

  def icon_classes
    "text-sm transition-transform group-hover:scale-110 duration-300"
  end
end
