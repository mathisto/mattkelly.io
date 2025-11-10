class Terminal::CursorComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  private

  def cursor_classes
    class_names(
      "inline-block w-2 h-5 bg-[#bb9af7] ml-1 animate-pulse",
      @options[:class]
    )
  end
end
