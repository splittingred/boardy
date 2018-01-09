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
          if game.owned?
            say "Yes! #{username} has #{game.name}!"
          elsif game.preordered?
            say "#{username} has preordered #{game.name}."
          elsif game.want_to_buy?
            say "#{username} wants to buy #{game.name}, but does not own it."
          elsif game.want_to_play?
            say "#{username} wants to play #{game.name}, but does not own it."
          else
            say "#{username} wants #{game.name}, but does not own it."
          end
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

