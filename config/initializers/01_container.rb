require 'dry/system/container'
require 'dry/types'
require 'dry/struct'

class App < Dry::System::Container
  configure do |config|
    config.root = ::Rails.root
    config.name = :boardy
    config.auto_register = %w[app/domains]
  end

  load_paths!('lib', 'app', 'app/domains')

  register 'logger', Rails.logger
  register 'redis', Storage::Redis.instance.client
  register 'slack.web.client', ::Slack::Web::Client.new(token: ENV['SLACK_API_TOKEN'])
end

Import = App.injector

module Types
  include Dry::Types.module
end
