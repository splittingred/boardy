require 'slack-ruby-bot'
SlackRubyBot::Commands::Base.command_classes = []
require 'patches'
require 'boardy/bot'
require 'bgg_api'

Dir["#{Rails.root}/app/services/commands/**/*.rb"].each { |f| load(f) unless f.include?('base.rb') }

Slack.configure do |config|
  config.token = Settings.slack.api_token
  config.logger = Logger.new(STDOUT)
  config.logger.level = Logger.const_get(Settings.logging.slack_api_level.to_s.upcase.to_sym)
end

# setup bot configs
SlackRubyBot.configure do |config|
  config.send_gifs = false
  config.aliases = ['bgg']
  config.logger = Logger.new(STDOUT)
  config.logger.level = Logger.const_get(Settings.logging.slack_bot_level.to_s.upcase.to_sym)
end

