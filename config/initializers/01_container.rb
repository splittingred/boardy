# frozen_string_literal: true

require 'dry/system/container'
require 'dry/types'
require 'dry/struct'

module Boardy
  class Container < ::Dry::System::Container
    configure do |config|
      config.root = "#{::Rails.root}/app"
      # config.name = :boardy
      config.auto_register = %w[app/domains app/services]
    end

    load_paths!('models', 'domains', 'jobs')

    register 'logger', Rails.logger
    register 'redis', Storage::Redis.instance.client
    register 'slack.web.client', ::Slack::Web::Client.new(token: ENV['SLACK_API_TOKEN'])
  end
end

module Boardy
  Import = Boardy::Container.injector
end

module Types
  include Dry::Types.module
end
