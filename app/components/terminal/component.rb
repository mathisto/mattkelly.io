class Terminal::Component < ApplicationComponent
  renders_one :header, Terminal::HeaderComponent
  renders_many :prompts, Terminal::PromptComponent

  def initialize(**options)
    @options = options
  end

  private

  def terminal_classes
    class_names(
      "terminal-container max-w-3xl mx-auto",
      @options[:class]
    )
  end

  def terminal_inner_classes
    "bg-[#1f2335]/95 backdrop-blur-sm rounded-lg p-6 border border-[#29293f] shadow-lg font-mono"
  end
end
