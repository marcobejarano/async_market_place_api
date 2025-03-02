require_relative "boot"

require "rails"
require "dotenv"

# Load environment variables only in development and test enviroments
if Rails.env.development? || Rails.env.test?
  Dotenv.load
end

# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AsyncMarketPlaceApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Explicitly enable session middleware in API mode for Sidekiq Web
    config.middleware.use ActionDispatch::Session::CookieStore, key: "_async_market_place_session"

    config.active_record.primary_key = :uuid
    config.active_job.queue_adapter = :sidekiq

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    config.eager_load_paths << Rails.root.join("lib")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.generators do |g|
      g.test_framework :rspec, fixture: true  # Use RSpec for tests and enable fixtures
      g.fixture_replacement :factory_bot, dir: "spec/factories"  # Use FactoryBot for fixtures
    end
  end
end
