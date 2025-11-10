source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.4.6"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.2"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.4"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Use Tailwind CSS [https://github.com/rails/tailwindcss-rails]
gem "tailwindcss-rails"
# HTTP client for making API requests
gem "httparty"

# Rails 8 Solid* stack for caching, jobs, and cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Markdown processing
gem "redcarpet", "~> 3.6"
# ViewComponent for view layer architecture
gem "view_component"
# Lookbook for component previews and documentation
gem "lookbook"

# Scribe dependencies
gem "ransack"  # Search and filtering
gem "kaminari"  # Pagination

# Mission Control - Jobs UI (development only)
gem "mission_control-jobs"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", "~> 0.1.12", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  # Testing framework
  gem "rspec-rails"
  gem "faker"
  gem "simplecov", require: false
  gem "capybara"
  gem "selenium-webdriver", "~> 4.10.0"
  gem "webdrivers", "~> 5.3.0"
  gem 'dotenv-rails'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  gem "sqlite3"
end

gem "dockerfile-rails", ">= 1.7", :group => :development

gem "aws-sdk-s3", "~> 1.182", :require => false

gem "litestream", "~> 0.12.0"
