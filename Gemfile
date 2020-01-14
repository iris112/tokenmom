source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'rake', '~> 12.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.1'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
gem 'daemons-rails'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use jquery for bootstrap
gem 'jquery-rails'
# Use bootstrap popover
gem 'bootstrap-popover-rails'
# Use bootstrap
gem 'bootstrap'

# mobile detection
gem 'browser', '2.0.3'

# Use font awesome
gem 'font-awesome-sass'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

#trestle admin gem
gem 'trestle', '0.8.9'
gem 'trestle-auth', '0.2.4'
gem 'trestle-search'
#web3 server script
gem 'web3-eth'
gem 'eth'
gem 'ethereum.rb'
gem 'hanna-nouveau', '~>1.0'
gem 'httparty','~>0.14'
gem 'json', '~>2'
# gem 'web3', '~> 0.4.1'


# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use haml for views
gem 'haml', '>= 3.1.alpha.50'
# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'
# Use seed_dump for db backup
gem 'seed_dump'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem 'mailcatcher'
gem 'figaro'
gem 'dotenv-rails'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# For UDF protocol
gem 'grape'
gem 'rack-cors', :require => 'rack/cors'
gem 'grape-active_model_serializers'
gem 'grape-swagger'

group :development do
  gem 'capistrano', '~> 3.11'
  gem 'capistrano-rails', '~> 1.4'
  gem 'capistrano-rbenv', '~> 2.1', '>= 2.1.4'
  gem 'capistrano-bundler', '~> 1.3'
  gem 'capistrano-passenger', '~> 0.2.0'
end

git "https://github.com/izetex/digest-sha3-ruby" do
gem 'digest-sha3'
end
