require 'games/errors'

module Commands
  module Bgg
    module Games
      class WhoHas < ::Commands::Base
        on :command, 'who has'

        def call
          game_name = expression.to_s.chomp('?')
          game = games.find_by_name(game_name)

          if game.owned_by.any?
            say "#{game.name} is owned by #{game.owned_by.join(', ')}"
          else
            say "No one owns #{game.name} :("
          end
        rescue ::Games::Errors::GameNotFound => _e
          say "No such game exists named #{game_name}"
        end
      end
    end
  end
end

