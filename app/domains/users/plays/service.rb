module Users
  module Plays
    class Service
      def played?(user:, game:)
        plays(user: user, game: game).to_a.any?
      end

      def plays(user:, game:)
        ::Bgg::Request::Plays.board_games(user.bgg_username, game.bgg_id, page: 1).get
      end
    end
  end
end
