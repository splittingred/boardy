require 'games/errors'

module Commands
  module Bgg
    class Game < ::Commands::Base
      on :command, 'game'

      def call
        game = games.find_by_name(expression.to_s)
        ::Messages::Bgg::Game.new(game).publish(channel)
      rescue ::Games::Errors::GameNotFound => _
        say "Game #{expression} not found in BGG database"
      end
    end
  end
end

