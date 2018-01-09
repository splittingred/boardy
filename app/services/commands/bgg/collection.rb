module Commands
  module Bgg
    class Collection < ::Commands::Base
      on :match, /How many games does (.*) have\?/i

      include ::Import[
        games_service: 'games.service'
      ]

      def call
        username = translator.translate(match[1])
        result = games_service.user_collection(username)
        say "#{username} has #{result.count} games."
      rescue Games::Errors::ResultProcessing
        say 'Boardgamegeek is currently processing this request. Try back in a few.'
      end

      private

      def translator
        @translator ||= ::Bgg::UsernameMap.new
      end
    end
  end
end

