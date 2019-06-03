module Games
  module Suggestions
    ##
    # For game suggestions
    #
    class Service
      ##
      # Suggest a game based on search criteria.
      #
      # @param [Integer] player_count (Optional) Within a certain player count
      # @param [Boolean] ranked (Optional) Only suggest bgg ranked games
      # @param [Boolean] random (Optional) Randomize selection
      # @param [Integer] min_time (Optional) Only suggest games where playtime is at least this long
      # @param [Integer] max_time (Optional) Only suggest games where playtime is at most this long
      # @param [Boolean] played (Optional) If true, suggest only played games. If false, only unplayed games. If nil, either. Requires users parameter.
      # @param [Array<Entities::User>] users (Optional) Required with played. Filter played games by these users.
      # @param [Integer] limit (Optional) Limit to X number of games in the final search. Useful with random.
      # @return [Entities::Game]
      #
      def search(player_count: 0, ranked: false, random: false, min_time: 0, max_time: 0, played: nil, users: [], limit: 100)
        users ||= []

        q = ::Game.distinct.owned.limit(limit)
        q = q.in_player_range(player_count, player_count) if player_count.to_i.positive?
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
