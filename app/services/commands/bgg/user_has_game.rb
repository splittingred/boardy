module Commands
  module Bgg
    class UserHasGame < ::Commands::Base
      on :match, /does (.*) have (.*)\?/i

      include ::Import[
        games_service: 'games.service'
      ]

      def call
        username = translator.translate(match[1])
        desired_game = match[2]

        game = games_service.user_has_game?(user: username, game: desired_game)
        if game
          say "#{username} has #{game.name}!"
        else
          say "#{username} does not have #{desired_game}"
        end
      rescue Games::Errors::ResultProcessing
        say 'Boardgamegeek is currently processing this request. Try back in a few.'
      rescue StandardError => e
        say e.message
      end

      private

      def translator
        @translator ||= ::Bgg::UsernameMap.new
      end
    end
  end
end

