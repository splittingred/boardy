module Users
  class IndexCollectionJob < ApplicationJob
    queue_as :default

    def perform(username, reindex = false, channel = nil)
      indexer = Collections::Indexer.new
      indexer.index(username: username, reindex: reindex, channel: channel)
    end
  end
end
