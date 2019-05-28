module Commands
  module Bgg
    module Suggestions
      class Game < ::Commands::Base
        on :match, /^(?<bot>\S*) suggest a (?<types>(.*)) game for (?<players>\d*)/i

        def call
          players = (match[:players] || 4).to_i
          types = (match[:types] || 'random').split(', ').map(&:strip)

          random = types.include?('random')
          ranked = types.include?('ranked')
          min_time = 0
          max_time = 0
          if types.include?('short')
            min_time = 0
            max_time = 45
          elsif types.include?('medium')
            min_time = 45
            max_time = 90
          elsif types.include?('long')
            min_time = 90
            max_time = 9_999
          end

          game = suggestions.search(
            player_count: players,
            min_time: min_time,
            max_time: max_time,
            ranked: ranked,
            random: random,
            limit: 100
          )

          if game
            ::Messages::Bgg::Game.new(game).publish(channel)
          else
            say 'No game matches that criteria. Please search again.'
          end
        end

        def suggestions
          @suggestions ||= App['games.suggestions.service']
        end
      end
    end
  end
end

