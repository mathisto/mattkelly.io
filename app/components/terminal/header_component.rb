class Terminal::HeaderComponent < ApplicationComponent
  def initialize(title: nil, **options)
    @title = title
    @options = options
  end

  private

  def header_classes
    class_names(
      "terminal-header flex items-center gap-2 mb-4 pb-3 border-b border-[#29293f]",
      @options[:class]
    )
  end
end
