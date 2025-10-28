class SiteBuilder < Bridgetown::Builder
  # write builders which subclass SiteBuilder in plugins/builders
end

# Ensure esbuild assets exist for non-development builds
Bridgetown::Hooks.register :site, :pre_render do |site|
  # Treat anything except explicit "development" as a production-like build
  next if ENV["BRIDGETOWN_ENV"] == "development"

  manifest = File.join(site.root_dir, ".bridgetown-cache", "frontend-bundling", "manifest.json")
  static_dir = File.join(site.root_dir, site.config["destination"], "_bridgetown", "static")

  unless File.exist?(manifest) && Dir.exist?(static_dir) && !Dir.children(static_dir).empty?
    puts "[build] esbuild assets missing. Running `npm run esbuild`..."
    system({ "NODE_ENV" => "production" }, "npm", "run", "esbuild")
  end
end
