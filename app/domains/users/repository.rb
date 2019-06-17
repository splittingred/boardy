require_relative 'errors'

module Users
  class Repository
    include ::Boardy::Import[
      slack: 'slack.clients.user'
    ]

    ##
    # Return all users
    #
    # @return [Entities::Collection<Entities::User>]
    #
    def all
      total = User.count
      entities = User.find_each.map(&:to_entity)
      Entities::Collection.new(entities: entities, total: total)
    end

    ##
    # Find a user by its ID
    #
    # @param [Integer] id
    # @return [Entities::User]
    #
    def find(id)
      ::User.find(id).to_entity
    rescue ActiveRecord::RecordNotFound
      raise Users::Errors::UserNotFound, "No user found in Boardy with ID #{id}"
    end

    ##
    # @param [String] username
    # @return [Entities::User]
    #
    def find_by_bgg_username(username)
      user = ::User.with_bgg_username(username).first!
      user.to_entity
    rescue ActiveRecord::RecordNotFound
      raise Users::Errors::UserNotFound, "No user found in Boardy with BGG username #{username}"
    end

    ##
    # Find by either slack or bgg username or slack ID
    #
    # @param [String] username
    # @return [Entities::User]
    #
    def find_by_usernames(username)
      user = ::User.where('bgg_username = ? OR slack_username = ? OR slack_id = ?', username, username, username).first!
      user.to_entity
    rescue ActiveRecord::RecordNotFound
      raise Users::Errors::UserNotFound, "No user found in Boardy with username #{username}"
    end

    ##
    # Find a user by its Slack ID
    #
    # @param [String] slack_id
    # @return [Entities::User]
    #
    def find_by_slack_id(slack_id)
      raise Users::Errors::UserNotFound, "No slack_id specified when finding user in UserRepository: #{slack_id}" unless slack_id.to_s.present?

      entity = from_cache(slack_id)
      unless entity
        slack_user = slack.by_id(slack_id)
        raise Users::Errors::UserNotFound, "User not found in Slack with Slack ID #{slack_id}" unless slack_user&.id

        obj_user = ::User.build_from_slack_user(slack_user) # eventually replace @user with this
        obj_user.save!
        entity = obj_user.to_entity
        cache(slack_id, entity)
      end
      entity
    end

    ##
    # Persist a user back into the DB
    #
    # @param [UserEntity] user_entity
    # @return [UserEntity]
    #
    def save(user_entity)
      user = ::User.with_slack_id(user_entity.slack_id).first_or_initialize
      user.slack_id = user_entity.slack_id
      user.slack_team_id = user_entity.slack_team_id
      user.slack_username = user_entity.slack_username
      user.bgg_username = user_entity.bgg_username
      user.email = user_entity.email
      user.first_name = user_entity.first_name
      user.last_name = user_entity.last_name
      user.title = user_entity.title
      user.collection_indexed = user_entity.collection_indexed
      user.save!
      clear_cache(user_entity.slack_id)
      find(user_entity.id)
    end

    private

    def cache(id, entity)
      cache_client.cache(id, entity.to_h)
    end

    def clear_cache(id)
      cache_client.clear(id)
    end

    def from_cache(slack_id)
      hash = cache_client.fetch(slack_id)
      hash ? Entities::User.new(hash) : nil
    end

    def cache_client
      @cache_client ||= Boardy::Container['users.cache']
    end
  end
end
