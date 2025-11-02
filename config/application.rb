require_relative "boot"

require "rails/all"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "action_mailer/railtie"
require "action_cable/engine"
require "active_storage/engine"
require "action_text/engine"
require "action_mailbox/engine"
require "rails/test_unit/railtie"
require "sidekiq/api"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*{.*.yml,.yml}')]
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '*/')]
    config.eager_load_paths += Dir[Rails.root.join('app', 'models', '*/')]

    #config.api_only = true
    config.i18n.available_locales = %i[en-Us en pt-BR es]
    config.i18n.default_locale = :'pt-BR'

    config.active_record.time_zone_aware_types = [:datetime]

    # Session managed required (for Sidekiq mounting)
    config.session_store :cookie_store, key: "_interslice_session"

    # Required for all session management
    config.middleware.use ActionDispatch::Cookies

    config.middleware.use config.session_store, config.session_options

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any,
                      methods: %i[get post delete put patch options head]
      end
    end
  end
end
