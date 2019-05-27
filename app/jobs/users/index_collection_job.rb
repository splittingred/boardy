module Users
  class IndexCollectionJob < ApplicationJob
    queue_as :default

    def perform(username)
      logger.info "Indexing user: #{username}"
      collection = lookup(username: username)
      collection.each do |item|
        game = ::Game.with_bgg_id(item.id).first
        next if game

        logger.info "- Mapping game: #{item.name} - #{item.id}"
        map(item)
        sleep 2 # to not beat rate limits
      end
      true
    end

    def lookup(username:, tries: 1)
      ::BggApi.collection(username, subtype: 'boardgame', excludesubtype: 'boardgameexpansion')
    rescue StandardError || RuntimeError => e
      if e.message.include?('202')
        raise if tries > 10
        logger.info "Received a 202 from BGG, sleeping 3s and trying again"
        sleep 3
        lookup(username: username, tries: tries + 1 )
      else
        raise
      end
    end

    def map(item)
      game = ::Bgg::Game.find_by_id(item.id)

      ::Game.create!(
        bgg_id: game.id,
        name: game.name,
        description: HTMLEntities.new.decode(game.description),
        year_published: game.year_published,
        min_players: game.min_players.to_i,
        max_players: game.max_players.to_i,
        min_playtime: game.min_playtime.to_i,
        max_playtime: game.max_playtime.to_i,
        min_age: game.recommended_minimum_age.to_i,
        image: game.image,
        thumbnail: game.thumbnail,
        board_game_rank: game.stats.board_game_rank == 'N/A' ? 0 : game.stats.board_game_rank,
        strategic_rank: game.stats.strategic_rank == 'N/A' ? 0 : game.stats.strategic_rank,
        thematic_rank: game.stats.thematic_rank == 'N/A' ? 0 : game.stats.thematic_rank,
        average_rating: game.stats.average_rating,
        users_rated: game.stats.users_rated,
        owners: game.stats.owners,
        mechanics: game.mechanics.join(', ')
      )
    rescue StandardError => e
      logger.error "-- Could not index game: #{item.name} - #{item.id}: #{e.message}"
    end
  end
end
