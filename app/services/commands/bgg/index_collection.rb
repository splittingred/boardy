module Commands
  module Bgg
    class IndexCollection < ::Commands::Base
      on :command, 'index collection'

      def call
        username = clean_slack_username(expression.split(' ').first)
        reindex = expression.split(' ').last == 'true'
        user = find_user(username)

        ::Users::IndexCollectionJob.perform_later(user.bgg_username, reindex, channel)

        say "Collection indexing begun for #{user.bgg_username}"
      rescue Games::Errors::GameNotFound => _
        say "Game #{expression} not found"
      end

      private

      def find_user(username)
        users.find_by_usernames(username)
      rescue StandardError => _
        users.find_by_slack_id(username)
      end
    end
  end
end

