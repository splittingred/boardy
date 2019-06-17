module Collections
  module Jobs
    class ReindexAll < ApplicationJob
      @queue = :default

      def perform
        logger.info 'Re-indexing user collections'
        users.all.each do |user|
          logger.info "Queueing #{user.bgg_username}'s collection to re-index"
          ::Collections::Jobs::Index.perform_later(user.bgg_username)
        end
      end

      private

      def users
        Boardy::Container['users.service']
      end
    end
  end
end
