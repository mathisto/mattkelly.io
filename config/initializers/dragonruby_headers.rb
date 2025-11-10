# Add COOP/COEP headers for DragonRuby WASM static files
# Required for SharedArrayBuffer support

class DragonRubyHeadersMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)

    # Add headers to /dragonruby/ files (static or dynamic)
    path = env["PATH_INFO"]
    if path.start_with?("/dragonruby/")
      headers["Cross-Origin-Embedder-Policy"] = "require-corp"
      headers["Cross-Origin-Opener-Policy"] = "same-origin"
    end

    [ status, headers, body ]
  end
end

# Insert BEFORE static handler so headers apply to static files too
Rails.application.config.middleware.insert_before ActionDispatch::Static, DragonRubyHeadersMiddleware
