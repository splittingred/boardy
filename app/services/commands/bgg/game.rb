module Commands
  module Bgg
    class Game < ::Commands::Base
      on :command, 'game'

      include ::Import[
        games_service: 'games.service'
      ]

      def call
        game = games_service.find_by_name(expression.to_s)
        ::Messages::Bgg::Game.new(game).publish(channel)
      rescue Games::Errors::GameNotFound => _
        say "Game #{expression} not found"
      end
    end
  end
end

