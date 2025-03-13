# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'

# Load Rails without eager loading
require 'rails'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'rails/test_unit/railtie'
require 'active_model/railtie'
require 'propshaft'

# Load the application configuration and routes without eager loading
require File.expand_path('../config/application', __dir__)
Rails.application.config.eager_load = false
require File.expand_path('../config/routes', __dir__)

require 'rspec/rails'
require 'capybara/rspec'

# Add additional requires below this line. Rails is not loaded until this point!
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Remove ActiveRecord migration check

RSpec.configure do |config|
  # Configure Capybara
  Capybara.register_driver :selenium_chrome_headless do |app|
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    options.add_argument('--disable-gpu')
    
    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      options: options
    )
  end

  Capybara.default_driver = :rack_test
  Capybara.javascript_driver = :selenium_chrome_headless
  Capybara.default_max_wait_time = 5

  # Filter lines from Rails gems in backtraces
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end
