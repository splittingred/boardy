module Messages
  class Publisher
    include Singleton

    def client
      @client ||= ::Slack::Web::Client.new
    end

    def publish(message, channel, options = {})
      options.merge!(channel: channel,
                     text: message,
                     as_user: true)
      client.chat_postMessage(options)
    end
  end
end
