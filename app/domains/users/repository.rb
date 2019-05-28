require_relative 'errors'

module Users
  class Repository
    def find_by_slack_id(slack_id)
      raise Users::Errors::UserNotFound, "No slack_id specified when finding user in UserRepository: #{slack_id}" unless slack_id.to_s.present?

      entity = false # from_cache(slack_id)
      unless entity
        slack_user = ::Slack::Clients::User.by_id(slack_id)
        raise Users::Errors::UserNotFound, "User not found in Slack with Slack ID #{slack_id}" unless slack_user&.id

        obj_user = ::User.build_from_slack_user(slack_user) # eventually replace @user with this
        obj_user.save!

        entity = ::Entities::User.new(
          slack_id: slack_user.id,
          slack_team_id: slack_user.team_id,
          bgg_username: obj_user.bgg_username,
          name: slack_user.name,
          id: obj_user.id,
          email: obj_user.email,
          first_name: obj_user.first_name,
          last_name: obj_user.last_name,
          title: obj_user.title
        )
        # cache(slack_id, entity)
      end
      entity
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
      hash ? UserEntity.new(hash) : nil
    end

    def cache_client
      @cache_client ||= App['users.cache']
    end
  end
end
