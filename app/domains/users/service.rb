module Users
  class Service
    include ::Boardy::Import[
      repository: 'users.repository'
    ]

    ##
    # Return all users
    #
    # @return [Entities::Collection<Entities::User>]
    #
    def all
      repository.all
    end

    ##
    # Find a user by its Slack ID
    #
    # @param [String] slack_id
    # @return [Entities::User]
    #
    def find_by_slack_id(slack_id)
      repository.find_by_slack_id(slack_id)
    end

    ##
    # Find by either slack or bgg username or slack ID
    #
    # @param [String] username
    # @return [Entities::User]
    #
    def find_by_usernames(username)
      repository.find_by_usernames(username)
    end

    ##
    # Save a user
    #
    # @param [Entities::User] user
    # @return [Entities::User]
    #
    def save(user)
      repository.save(user)
    end

    ##
    # Index a user's collection
    #
    def index_collection!(user:, reindex: false, channel: nil)
      ::Collections::Jobs::Index.perform_later(user.bgg_username, reindex, channel)
    end
  end
end
