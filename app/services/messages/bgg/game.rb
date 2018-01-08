require 'htmlentities'

module Messages
  module Bgg
    class Game
      attr_reader :game

      def initialize(game)
        @game = game
      end

      ##
      # @param [String] channel
      #
      def publish(channel)
        ::Messages::Publisher.instance.publish(
          '',
          channel,
          attachments: [
            {
              fallback: '',
              color: '#36a64f',
              pretext: '',
              title: "#{game.name}",
              title_link: link,
              text: HTMLEntities.new.decode(game.description),
              fields: [
                {
                  title: 'Playing Time',
                  value: "#{game.playing_time} min",
                  short: true
                },{
                  title: '# Players',
                  value: "#{game.min_players}-#{game.max_players}",
                  short: true
                },{
                  title: 'Rank',
                  value: game.stats.board_game_rank.to_s,
                  short: true
                },{
                  title: 'Strategic Rank',
                  value: game.stats.strategic_rank.to_s,
                  short: true
                },{
                  title: 'Thematic Rank',
                  value: game.stats.thematic_rank.to_s,
                  short: true
                },{
                  title: 'Rating',
                  value: game.stats.average_rating,
                  short: true
                },{
                  title: 'Mechanics',
                  value: game.mechanics.join(', '),
                  short: false
                }
              ],
              image_url: game.thumbnail,
              footer: footer,
              ts: DateTime.current.to_i
            }
          ]
        )
      end

      private

      def link
        "https://boardgamegeek.com/boardgame/#{game.id}"
      end

      def footer
        "#{game.categories.join(', ')}. By #{game.artists.join(', ')} in #{game.year_published}"
      end
    end
  end
end
