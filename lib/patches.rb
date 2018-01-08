module SlackRubyBot
  module Commands
    class Base
      class << self
        def inherited(subclass)
          return if excluded_classes.include?(subclass)
          SlackRubyBot::Commands::Base.command_classes ||= []
          SlackRubyBot::Commands::Base.command_classes << subclass
          SlackRubyBot::Commands::Base.command_classes.uniq!
          SlackRubyBot::Commands::Base.command_classes
        end

        def excluded_classes
          [
              #::Boardy::Commands::Base,
              ::Boardy::Bot,
              ::Commands::Base
          ]
        end

        def call_command(client, data, match, block)
          if block
            block.call(client, data, match) if permitted?(client, data, match)
          elsif respond_to?(:call)
            send(:call, client, data, match) if permitted?(client, data, match)
          else
            Rails.logger.warn "Not implemented in #{name}: #{data.text} - #{match.inspect}"
            # raise NotImplementedError, data.text
            # NOOP here because raising an error is dumb
          end
        end
      end
    end

    class Unknown < Base
      def self.call(_client, _data, _match)
        # client.say(channel: data.channel, text: "<@#{data.user}>, PHRASING!")
        # NOOP because Heroku is dumb
      end
    end
  end

  module Hooks
    class Message
      def built_in_command_classes
        []
      end
    end
  end
end
