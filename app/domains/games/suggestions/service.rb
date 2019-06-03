module Games
  module Suggestions
    ##
    # For game suggestions
    #
    class Service
      def search(player_count: 0, ranked: false, played: nil, random: false, min_time: 0, max_time: 0, users: [], limit: 100)
        users ||= []

        q = ::Game.distinct.in_player_range(player_count, player_count).owned.limit(limit)
        q = q.highest_rank if ranked
        q = q.random if random
        q = q.within_time_range(min_time, max_time) if min_time.positive? || max_time.positive?
        return nil unless q.any?

        if played.is_a?(TrueClass)
          q = q.played(users.map(&:id))
        elsif played.is_a?(FalseClass)
          q = q.unplayed(users.map(&:id))
        end

        games = q.all
        idx = rand(0..(games.count-1))
        games[idx].to_entity
      end
    end
  end
end
