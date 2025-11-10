class Terminal::ComponentPreview < Lookbook::Preview
  # Simple terminal
  # ---------------
  # Basic terminal with header and prompts
  def simple
    render Terminal::Component.new do |terminal|
      terminal.with_header(title: "zsh")

      terminal.with_prompt(command: "whoami") do |prompt|
        prompt.with_output { "mattkelly" }
      end

      terminal.with_prompt(command: "pwd") do |prompt|
        prompt.with_output { "/Users/mattkelly/projects" }
      end
    end
  end

  # ASCII art terminal
  # ------------------
  # Terminal displaying ASCII art
  def ascii_art
    render_with_template
  end

  # Interactive terminal
  # --------------------
  # Terminal with cursor
  def with_cursor
    render Terminal::Component.new do |terminal|
      terminal.with_header

      terminal.with_prompt(command: "echo 'Hello, World!'") do |prompt|
        prompt.with_output { "Hello, World!" }
      end

      <<~HTML.html_safe
        <div class="command-prompt flex items-center">
          <span class="prompt-symbol text-[#9ece6a] mr-2">❯</span>
          #{render Terminal::CursorComponent.new}
        </div>
      HTML
    end
  end

  # Full example
  # ------------
  # Complete terminal showcase
  def showcase
    render_with_template
  end
end
