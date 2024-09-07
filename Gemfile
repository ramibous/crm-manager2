source "https://rubygems.org"

ruby "3.1.6"

gem "rails", "~> 7.1.4"
gem "sprockets-rails"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "redis", ">= 4.0.1"
gem "tzinfo-data", platforms: %i[mswin mswin64 mingw x64_mingw jruby]
gem "bootsnap", require: false
gem 'wicked_pdf'
gem 'caxlsx_rails'  # Use caxlsx_rails instead of axlsx_rails

# Additional gems
gem 'bootstrap', '~> 5.1.3'
gem 'sassc-rails'
gem 'sassc'  # Add this if using sassc-rails
gem 'devise'
gem 'groupdate'
gem 'faker'  # Available in all environments

# Optionally use CDN for Bootstrap Icons or keep the gem
gem 'bootstrap-icons', '~> 1.0.14'

group :development, :test do
  gem 'debug', platforms: %i[mri mswin mswin64 mingw x64_mingw]
  gem 'rspec-rails', '~> 5.0'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry'
  gem 'pry-rails'
end

group :development do
  gem "web-console"
  gem "error_highlight", ">= 0.4.0", platforms: [:ruby]
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

group :production do
  gem 'pg', '~> 1.1'
  gem 'puma', '>= 5.0'
  gem 'terser'
end