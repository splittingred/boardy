module Collections
  module Jobs
    class Index < ApplicationJob
      queue_as :default

      def perform(username, reindex = false, channel = nil)
        indexer = Collections::Indexer.new
        indexer.index(username: username, reindex: reindex, channel: channel)
      end
    end
  end
end
