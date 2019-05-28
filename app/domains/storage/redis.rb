module Storage
  class Redis
    include Singleton

    attr_reader :client

    def initialize
      data = { url: Settings.redis.url.to_s }
      pw = Settings.redis.password.to_s
      data[:password] = pw if pw.present?
      @client = ::Redis.new(data)
    end
  end
end
