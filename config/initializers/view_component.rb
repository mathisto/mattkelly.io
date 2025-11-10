Rails.application.configure do
  config.view_component.preview_paths = [ Rails.root.join("spec/components/previews") ]
  config.view_component.show_previews = true

  # Lookbook configuration
  config.lookbook.page_paths = [ Rails.root.join("spec/components/docs") ]
  config.lookbook.preview_display_options = {
    theme: "dark"
  }

  # Don't lazy load - load previews immediately
  config.lookbook.lazy_load_previews_and_pages = false
end
