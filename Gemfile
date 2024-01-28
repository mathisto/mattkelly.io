source "https://rubygems.org"

ruby "3.3.0"

gem "amazing_print"
gem "capistrano-passenger", "~> 0.2.0"
gem "capistrano-rails", "~> 1.4"
gem "capistrano-rbenv", "~> 2.1", ">= 2.1.4"
gem "capistrano", "~> 3.11"
gem "bootsnap", require: false
gem "importmap-rails"
gem "htmx-rails"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "rails", "~> 7.1.2"
gem "sprockets-rails"
gem "tzinfo-data", platforms: %i[windows jruby]

group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "rspec-rails", "~> 6.1.0"
  gem "standard"
end

group :development do
  gem "web-console"
  gem "rack-mini-profiler"
  gem "spring"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
