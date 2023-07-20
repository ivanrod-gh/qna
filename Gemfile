source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.7'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Use slim template engine
gem 'slim-rails', '~> 3.6.0'
# Authentication
gem 'devise', '~> 4.0'
# GitHub API
gem 'octokit', '~> 5.0'
# UI - icons
gem 'octicons_helper', '~> 18.2.0'
# UI - dinamic add/edit/destroy resources
gem 'cocoon', '1.2.14'
# UI - add server data to frontend page
gem 'gon', '~> 6.4.0'
# Third party authentication
gem 'omniauth', '~> 1.9.2'
gem 'omniauth-github'
gem 'omniauth-yandex'
# Authorization
gem 'cancancan', '~> 3.5.0'
# Add OAuth providing function to application
gem 'doorkeeper', '~> 5.6.6'
# Create and fill application response
gem 'active_model_serializers', '~> 0.10.13'
gem 'oj'
# Adapter sidekiq for ActiveJob
gem 'sidekiq', '~> 7.0.0'
# Web-interface for sidekiq
gem 'sinatra', '~> 3.0.0', require: false
# Crone helper
gem 'whenever', require: false
# Full-text search
gem 'mysql2', '~> 0.4.0'
gem 'thinking-sphinx', '~> 5.5.0'
# Generate test data
gem 'faker', '~> 3.1.0'
# Unicorn application server
gem 'unicorn', '~> 6.0.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'aws-sdk-s3', '~> 1'
  gem 'letter_opener', '~> 1.8.0'
  # Deploy
  gem 'capistrano', '~> 3.17.0', require: false
  gem 'capistrano-bundler', '~> 2.1.0', require: false
  gem 'capistrano-rails', '~> 1.6.0', require: false
  gem 'capistrano-rbenv', '~> 2.2.0', require: false
  gem 'capistrano-passenger', '~> 0.2.1', require: false
  # gem 'capistrano-sidekiq', '~> 2.3.0', require: false
  gem 'capistrano3-unicorn', '~> 0.2.1', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver', '>= 4.0.0.rc1'
  gem 'launchy', '~> 2.5.0'
  gem 'rspec-rails', '~> 6.0.0'
  gem 'factory_bot_rails', '~> 6.2.0'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  gem 'shoulda-matchers', '~> 5.0'
  gem 'rails-controller-testing'
  # Full-text search DB cleaner
  gem 'database_cleaner-active_record', '~> 2.1.0'
end

group :production do
  # Use Redis adapter to run Action Cable in production
  gem 'redis', '~> 4.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
