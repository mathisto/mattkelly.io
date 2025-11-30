class Hero::TerminalComponent < ApplicationComponent
  def initialize(whoami: "Developer", role: "Building amazing things", **options)
    @whoami = whoami
    @role = role
    @options = options
  end

  private

  def ascii_art
    <<~ASCII
      __  __       _   _    _  __    _ _#{'       '}
      |  \\/  | __ _| |_| |_ | |/ /___| | |_   _#{' '}
      | |\\/| |/ _` | __| __|| ' // _ \\ | | | | |
      | |  | | (_| | |_| |_ | . \\  __/ | | |_| |
      |_|  |_|\\__,_|\\__|\\__||_|\\_\\___|_|_|\\__, |
                                          |___/
    ASCII
  end
end
