# Configure Propshaft to load Mission Control Jobs assets (the gem is not in every Bundler group)
if defined?(MissionControl::Jobs::Engine)
  Rails.application.config.assets.paths << MissionControl::Jobs::Engine.root.join("app/assets/stylesheets")
  Rails.application.config.assets.paths << MissionControl::Jobs::Engine.root.join("app/javascript")
end
