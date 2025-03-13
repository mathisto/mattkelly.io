require_relative "boot"

# Only load the parts of Rails we need
require "rails"

# Pick the frameworks you want:
require "action_controller/railtie"
require "action_view/railtie"
require "rails/test_unit/railtie"
require "active_model/railtie"
require "propshaft"

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
  end
end
