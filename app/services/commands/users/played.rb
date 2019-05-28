require 'users/errors'

module Commands
  module Users
    class Played < ::Commands::Base
      on :match, /has (.*) played (.*)\?/i
      on :match, /has (.*) played (.*)/i

      def call
        username = clean_slack_username(match[1])
        game = match[2].to_s
        user = users.find_by_usernames(username)

        if !user.collection_indexed?
          say "#{user.bgg_username} has not yet had their collection indexed."
        elsif user.played?(game)
          say "Yes, #{user.bgg_username} has played #{game}"
        else
          say "No, #{user.bgg_username} has not played #{game}"
        end
      rescue ::Users::Errors::UserNotFound => _e
        say "No user with username #{username} has been registered to Boardy yet."
      end
    end
  end
end

