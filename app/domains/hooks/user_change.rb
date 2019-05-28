module Hooks
  class UserChange
    include Import[
      users_repository: 'users.repository'
    ]

    def call(_client, data)
      user_entity = users_repository.find_by_slack_id(data['user']['id'])

      if data['user'] && data['user']['name']
        user_entity.slack_username = data['user']['name']
        users_repository.save(user_entity)
      end
    end
  end
end
