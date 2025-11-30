class Terminal::PromptComponent < ApplicationComponent
  renders_one :output, Terminal::OutputComponent

  def initialize(command:, **options)
    @command = command
    @options = options
  end

  private

  def prompt_classes
    class_names(
      "command-prompt flex items-center mb-2",
      @options[:class]
    )
  end
end
