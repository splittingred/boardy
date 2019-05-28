module Slack
  module Clients
    class User
      include Import[
        client: 'slack.web.client',
        logger: 'logger'
      ]

      def by_id(id)
        raise ::ArgumentError unless id.to_s.length > 0
        id.sub!(/^@/, '')

        user = client.users_info(user: id)
        if user['ok']
          user['user']
        else
          nil
        end
      rescue ::Slack::Web::Api::Error => e
        @logger.error "Error finding user #{id}: #{e.message}"
        nil
      end

      def kick(user_id, channel_id)
        user = by_id(user_id)
        channel = ::Clients::Slack::Channel.by_id(channel_id)

        raise ::ArgumentError, 'no such user!' unless user
        raise ::ArgumentError, 'no such channel!' unless channel

        kicked = client.channels_kick(channel: channel.id, user: user.id)
        if kicked['ok']
          true
        else
          nil
        end
      rescue ::Slack::Web::Api::Error => e
        @logger.error "Error kicking user #{user_id} from channel #{channel_id}: #{e.message}"
        nil
      end
    end
  end
end
