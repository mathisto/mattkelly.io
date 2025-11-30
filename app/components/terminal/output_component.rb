class Terminal::OutputComponent < ApplicationComponent
  def initialize(type: :text, **options)
    @type = type
    @options = options
  end

  private

  def output_classes
    class_names(
      "command-output text-[#a9b1d6] ml-6 mb-4",
      { "whitespace-pre font-mono text-sm" => @type == :ascii },
      @options[:class]
    )
  end
end
