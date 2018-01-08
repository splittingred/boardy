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
        ::Messages::Publisher.instance.publish('', channel,
          attachments: [
            {
              fallback: '',
              color: '#36a64f',
              pretext: '',
              title: "#{game.name}",
              title_link: link,
              text: game.description,
              fields: [
                {
                  title: 'Mechanics',
                  value: game.mechanics.join(', '),
                  short: true
              },{
                  title: 'Playing Time',
                  value: "#{game.playing_time} min",
                  short: true
              },{
                  title: 'Categories',
                  value: game.categories.join(', '),
                  short: true
              },{
                  title: 'Year',
                  value: game.year_published,
                  short: true
                }
              ],
              image_url: game.image,
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
        "#{game.min_players}-#{game.max_players} players. By #{game.artists.join(', ')}"
      end
    end
  end
end
