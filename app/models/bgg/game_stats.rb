module Bgg
  class GameStats < ::Hashie::Mash

    def users_rated
      usersrated.first.value.to_i
    rescue StandardError => _
      'N/A'
    end

    def average_rating
      average.first.value.to_f
    rescue StandardError => _
      'N/A'
    end

    def owners
      owned.first.value.to_i
    rescue StandardError => _
      'N/A'
    end

    def board_game_rank
      rk = ranks.first.rank.select do |r|
        r.name == 'boardgame'
      end.first
      rk.value.to_i
    rescue StandardError => _
      'N/A'
    end

    def thematic_rank
      rk = ranks.first.rank.select do |r|
        r.name == 'thematic'
      end.first
      rk.value.to_i
    rescue StandardError => _
      'N/A'
    end

    def strategic_rank
      rk = ranks.first.rank.select do |r|
        r.name == 'strategygames'
      end.first
      rk.value.to_i
    rescue StandardError => _
      'N/A'
    end

  end
end
