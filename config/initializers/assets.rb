# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.

# Add your service worker and other necessary files to be precompiled
Rails.application.config.assets.precompile += %w( service-worker.js manifest.js )

# If you have other custom assets (like admin.js or specific CSS files)
# you can add them as needed:
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
