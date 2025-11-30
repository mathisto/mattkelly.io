require_relative "boot"

# Only load the parts of Rails we need
require "rails"

%w[
  active_record/railtie
  active_job/railtie
  action_controller/railtie
  action_view/railtie
  action_cable/engine
  rails/test_unit/railtie
  active_model/railtie
  propshaft
].each do |railtie|
  begin
    require railtie
  rescue LoadError
  end
end

# Require the gems listed in Gemfile
Bundler.require(*Rails.groups)

module MattkellyIo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    config.time_zone = "UTC"

    # Use SolidQueue for background jobs
    config.active_job.queue_adapter = :solid_queue

    # Use SolidCache for caching
    config.cache_store = :solid_cache_store

    # Lookbook configuration - Tokyo Night theme
    config.lookbook.ui_theme_overrides = {
      # Color scales - Tailwind convention: 50=lightest, 900=darkest
      # For dark theme, invert so UI elements use darker values
      base_50: "#1a1b26",
      base_100: "#24283b",
      base_200: "#292e42",
      base_300: "#414868",
      base_400: "#565f89",
      base_500: "#787c99",
      base_600: "#a9b1d6",
      base_700: "#c0caf5",
      base_800: "#e0e7ff",
      base_900: "#f0f4ff",
      accent_50: "#1a1b26",
      accent_100: "#24283b",
      accent_200: "#414868",
      accent_300: "#565f89",
      accent_400: "#787c99",
      accent_500: "#a9b1d6",
      accent_600: "#c0caf5",
      accent_700: "#e0e7ff",
      accent_800: "#f0f4ff",
      accent_900: "#ffffff",

      # Header
      header_bg: "#1a1b26",
      header_text: "#c0caf5",
      header_border: "#414868",
      branding_text: "#7aa2f7",

      # Sidebar/Navigation
      sidebar_bg: "#16161e",
      nav_text: "#c0caf5",
      nav_toggle: "#7aa2f7",
      nav_icon_stroke: "#7aa2f7",
      nav_item_hover: "#24283b",
      nav_item_active: "#414868",

      # Page content
      page_bg: "#1a1b26",
      text: "#c0caf5",
      divider: "#414868",

      # Prose/Documentation
      prose_bg: "#1a1b26",
      prose_text: "#e0e7ff",
      prose_link: "#7aa2f7",
      prose_headings: "#f0f4ff",
      prose_strong: "#e0e7ff",
      prose_code: "#7dcfff",
      prose_em: "#c0caf5",

      # Buttons
      button_bg: "#7aa2f7",
      button_bg_hover: "#bb9af7",
      button_text: "#1a1b26",
      icon_button_stroke: "#a9b1d6",
      icon_button_stroke_hover: "#7aa2f7",

      # Inputs
      input_bg: "#24283b",
      input_border: "#414868",
      input_border_focus: "#7aa2f7",
      input_text: "#c0caf5",
      input_text_placeholder: "#565f89",

      # UI Elements
      toolbar_bg: "#1f2335",
      toolbar_divider: "#414868",
      dropdown_bg: "#24283b",
      dropdown_text: "#c0caf5",
      dropdown_divider: "#414868",
      tooltip_bg: "#24283b",
      tooltip_text: "#c0caf5",
      scrollbar: "#414868",
      scrollbar_hover: "#565f89",

      # Tabs
      tabs_text: "#a9b1d6",
      tabs_text_hover: "#c0caf5",
      tabs_text_disabled: "#565f89",
      tabs_border_active: "#7aa2f7"
    }
  end
end
