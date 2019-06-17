module Collections
  class Service
    def find_for_user(user, limit: 20)
      entities = []
      q = UserGame.distinct.includes(:game).references(:game).where(user_id: user.id, owned: true)
      total = q.count
      user_games = q.order(name: :asc).limit(limit)

      user_games.each do |ug|
        entities << ug.game.to_entity
      end

      Entities::Collection.new(
        entities: entities,
        total: total
      )
    end
  end
end
