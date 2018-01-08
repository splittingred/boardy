module Commands
  module Bgg
    class UserHasGame < ::Commands::Base
      on :match, /does (.*) have (.*)\?/i

      def call
        username = translator.translate(match[1])
        desired_game = match[2]

        collection = ::BggApi.collection(username)
        unless !collection || collection.xml.xpath('errors/error/message').children.first.to_s.empty?
          say collection.xml.xpath('errors/error/message').children.first.to_s
          return
        end

        game = collection.select { |g| g.name.to_s.downcase.include?(desired_game.to_s.downcase) && g.owned? }.first
        if game
          say "#{username} has #{game.name}!"
          ::Messages::Bgg::Game.new(game.game).publish(channel)
        else
          say "User does not have #{desired_game}"
        end
      end

      private

      def translator
        @translator ||= Bgg::UsernameMap.new
      end
    end
  end
end

