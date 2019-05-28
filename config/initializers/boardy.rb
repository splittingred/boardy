require 'slack-ruby-bot'
SlackRubyBot::Commands::Base.command_classes = []
require 'patches'
require 'boardy/bot'

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

Slack::RealTime.configure do |config|
  config.concurrency = Slack::RealTime::Concurrency::Async
  config.start_options[:simple_latest] = true
  config.start_options[:no_unreads] = true
  config.start_options[:request][:timeout] = 360
end
