# frozen_string_literal: true

require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
# require "action_mailer/railtie"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
require 'dotenv'
Dotenv.overload

module Boardy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Don't generate system test files.
    config.generators.system_tests = nil
    config.generators do |g|
      g.test_framework :rspec, fixture: true
      g.view_specs false
      g.helper_specs false
    end

    # for things to happen pre-fork
    config.before_fork_callbacks = []
    # for things to happen after-fork
    config.after_fork_callbacks = []
    # Hooks for code that should be done on worker boot
    config.on_worker_boot_callbacks = []

    config.eager_load_paths << "#{config.root}/lib"
    # config.eager_load_paths << "#{config.root}/app/domains"
    # config.eager_load_paths << "#{config.root}/app/services"

    config.eager_load_paths += Dir[Rails.root.join('app', 'domains', 'services', '{*}', 'models')]
    config.i18n.load_path += Dir[Rails.root.join('app', 'domains', '{*}', 'locale', '*.{rb,yml}').to_s]

    config.debug_exception_response_format = :api
  end
end
