require 'users/errors'
require 'games/errors'

module Commands
  module Users
    class Played < ::Commands::Base
      on :match, /has (.*) played (.*)\?/i
      on :match, /has (.*) played (.*)/i

      def call
        username = clean_slack_username(match[1])
        user = users.find_by_usernames(username)
        unless user.collection_indexed?
          say "#{user.bgg_username} has not yet had their collection indexed."
          return
        end

        game_name = match[2].to_s
        game = games.find_by_name(game_name)

        if plays.played?(user: user, game: game)
          say "Yes, #{user.bgg_username} has played #{game.name}"
        else
          say "No, #{user.bgg_username} has not played #{game.name}"
        end
      rescue ::Users::Errors::UserNotFound => _e
        say "No user with username #{username} has been registered to Boardy yet."
      rescue ::Games::Errors::GameNotFound => _e
        say "No game named #{game_name} found."
      end

      private

      def plays
        @plays ||= App['users.plays.service']
      end
    end
  end
end

