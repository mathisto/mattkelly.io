#!/usr/bin/env ruby
# Generate manifest.json for DragonRuby WASM from gamedata directory

require 'json'
require 'pathname'

gamedata_path = Pathname.new(File.expand_path('../public/dragonruby/gamedata', __dir__))
output_path = File.expand_path('../public/dragonruby/manifest.json', __dir__)

manifest = {}

# Recursively find all files in gamedata
Dir.glob("**/*", base: gamedata_path).each do |relative_path|
  full_path = gamedata_path.join(relative_path)

  next unless full_path.file?  # Skip directories

  # Get file stats
  stats = full_path.stat

  # Add to manifest with format matching DragonRuby WASM loader expectations
  # CRITICAL: Must use "filesize" and "filetime" NOT "size" and "timestamp"
  manifest[relative_path] = {
    "filesize" => stats.size,
    "filetime" => stats.mtime.to_i
  }
end

# Write manifest with pretty formatting
File.write(output_path, JSON.pretty_generate(manifest))

puts "✓ Generated manifest.json with #{manifest.keys.length} files"
puts "  Output: #{output_path}"
