module Hooks
  class UserChange
    include Import[
      users: 'users.service'
    ]

    def call(_client, data)
      user_entity = users.find_by_slack_id(data['user']['id'])

      if data['user'] && data['user']['name']
        user_entity.slack_username = data['user']['name']
        users.save(user_entity)
      end
    end
  end
end
