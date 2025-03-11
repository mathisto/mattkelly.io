# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
Rails.application.config.assets.paths << Rails.root.join("app/assets")
Rails.application.config.assets.paths << Rails.root.join("app/assets/stylesheets")
Rails.application.config.assets.paths << Rails.root.join("app/assets/javascripts")
Rails.application.config.assets.paths << Rails.root.join("app/assets/builds")
Rails.application.config.assets.paths << Rails.root.join("vendor/assets")
Rails.application.config.assets.paths << Rails.root.join("vendor/assets/stylesheets")

# Ensure assets are precompiled
Rails.application.config.assets.precompile += %w( 
  vendor.css
  application.css
  tailwind.css
)
