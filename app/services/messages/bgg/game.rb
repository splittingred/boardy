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
                  value: "#{game.min_playtime}-#{game.max_playtime} min",
                  short: true
                },{
                  title: '# Players',
                  value: "#{game.min_players}-#{game.max_players}",
                  short: true
                },{
                  title: 'Rank',
                  value: game.board_game_rank.to_s,
                  short: true
                },{
                  title: 'Strategic Rank',
                  value: game.strategic_rank.to_s,
                  short: true
                },{
                  title: 'Thematic Rank',
                  value: game.thematic_rank.to_s,
                  short: true
                },{
                  title: 'Rating',
                  value: game.average_rating,
                  short: true
                },{
                  title: 'Mechanics',
                  value: game.mechanics,
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
        "https://boardgamegeek.com/boardgame/#{game.bgg_id}"
      end

      def footer
        "" # "#{game.categories.join(', ')}. By #{game.artists.join(', ')} in #{game.year_published}"
      end
    end
  end
end
