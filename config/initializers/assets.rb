# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
Rails.application.config.assets.precompile += %w( turbolinks.js )
Rails.application.config.assets.precompile += %w( 0x-trading.js )
Rails.application.config.assets.precompile += %w( keythereum.min.js )
Rails.application.config.assets.precompile += %w( ethereumjs-util.js )
Rails.application.config.assets.precompile += %w( ethereumjs-tx-1.3.3.min.js )
Rails.application.config.assets.precompile += %w( buffer.js )
Rails.application.config.assets.precompile += %w( human_standard_info_abi.js )
Rails.application.config.assets.precompile += %w( main-jquery_i18n.js )
Rails.application.config.assets.precompile += %w( tv-chart-widget-init.js )
