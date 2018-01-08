module Commands
  module Bgg
    class Game < ::Commands::Base
      on :command, 'game'

      def call
        result = ::BggApi.search(expression, type: 'boardgame', exact: true, stats: 1)
        unless !result || result.xml.xpath('errors/error/message').children.first.to_s.empty?
          say result.xml.xpath('errors/error/message').children.first.to_s
          return
        end

        if result.first
          ::Messages::Bgg::Game.new(result.first.game).publish(channel)
        else
          say "Cannot find #{expression}"
        end
      end
    end
  end
end

