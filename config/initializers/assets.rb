# Configure Propshaft to load Mission Control Jobs assets
Rails.application.config.assets.paths << MissionControl::Jobs::Engine.root.join("app/assets/stylesheets")
Rails.application.config.assets.paths << MissionControl::Jobs::Engine.root.join("app/javascript")
