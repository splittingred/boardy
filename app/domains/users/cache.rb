module Users
  class Cache
    ##
    # Fetch a user out of the cache
    #
    def fetch(id)
      u = JSON.parse(client.get("#{cache_key_prefix}#{id}"))
      if DateTime.parse(u['expires_at']) > DateTime.current
        u['user']
      else
        clear(id)
        nil
      end
    rescue => _
      clear(id)
      nil
    end

    ##
    # Cache a user
    #
    def cache(id, user)
      client.set("#{cache_key_prefix}#{id}", {
        user: user,
        expires_at: DateTime.current + 1.week
      }.to_json)
    end

    ##
    # Flush all user caches
    #
    def flush
      ks = client.keys("#{cache_key_prefix}*")
      client.del(*ks) if ks.any?
    end

    ##
    # Clear cache for a user
    #
    def clear(id)
      client.del("#{cache_key_prefix}#{id}")
    end

    private

    def cache_key_prefix
      'user-'
    end

    def client
      Storage::Redis.instance.client
    end
  end
end
