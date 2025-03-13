require_relative "boot"

# Only load the parts of Rails we need
require "rails"

# Pick the frameworks you want:
require "action_controller/railtie"
require "action_view/railtie"
require "rails/test_unit/railtie"
require "active_model/railtie"
require "rails/log_subscriber"
require "active_support/logger"
require "propshaft"

# Require the gems listed in Gemfile
Bundler.require(*Rails.groups)

module MattkellyIo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Enable zeitwerk logging in development for debugging autoload issues
    config.autoloader = :zeitwerk
    Rails.autoloaders.log! if Rails.env.development?

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    config.time_zone = "UTC"

    # Configure logging
    config.log_level = :info
    config.logger = ActiveSupport::Logger.new(STDOUT)
    Rails.logger = config.logger

    # Configure autoloading - this is the proper way to handle autoload paths
    # as per the Rails guide
    config.before_initialize do |app|
      # Remove unnecessary autoload paths before they get frozen
      paths_to_remove = %w[jobs models mailers].map { |dir| "#{Rails.root}/app/#{dir}" }
      
      app.config.autoload_paths.reject! do |path|
        paths_to_remove.any? { |remove_path| path.to_s.start_with?(remove_path) }
      end
      
      app.config.eager_load_paths.reject! do |path|
        paths_to_remove.any? { |remove_path| path.to_s.start_with?(remove_path) }
      end
    end
  end
end
