source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.1"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.5", ">= 1.5.9"

# A fast, asynchronous, rack-compatible web server.
gem "falcon", "~> 0.50.0"

# Fast, simple and easy to use JSON:API serialization library (also known as fast_jsonapi).
gem "jsonapi-serializer", "~> 2.2"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1", ">= 3.1.20"

# A pure ruby implementation of the RFC 7519 OAuth JSON Web Token (JWT) standard
gem "jwt", "~> 2.10", ">= 2.10.1"

# Simple, efficient background processing for Ruby.
gem "sidekiq", "8.0.0.beta1"

# Kaminari is a Scope & Engine based, clean, powerful, agnostic, customizable and sophisticated paginator for Rails 4+
gem "kaminari", "~> 1.2", ">= 1.2.2"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  # Faker, a port of Data::Faker from Perl, is used to easily generate fake data: names, addresses, phone numbers, etc.
  gem "faker", "~> 3.5", ">= 3.5.1"

  # factory_bot_rails provides integration between factory_bot and rails 5.0 or newer
  gem "factory_bot_rails", "~> 6.4", ">= 6.4.4"
end

group :test do
  # rspec-rails integrates the Rails testing helpers into RSpec.
  gem "rspec-rails", "~> 7.1", ">= 7.1.1"

  # Shoulda Matchers provides RSpec- and Minitest-compatible one-liners to test common Rails functionality that, if written by hand, would be much longer, more complex, and error-prone.
  gem "shoulda-matchers", "~> 6.4"
end
