module Collections
  class Indexer
    include Import[
      logger: 'logger',
      slack: 'slack.web.client',
      users: 'users.service'
    ]

    def index(username:, reindex: false, channel: nil)
      logger.info "Indexing collection for user: #{username}"
      user = users.find_by_usernames(username)
      collection = lookup(user: user)
      collection.each do |item|
        game = ::Game.with_bgg_id(item.id).first
        game = game.to_entity if game

        reindex_game = !game || reindex

        logger.info "- Mapping game: #{item.name} - #{item.id}"
        game = persist_game(item: item) if reindex_game
        persist_user_game(game: game, item: item, user: user)
        sleep 2 if reindex_game # to not beat rate limits
      end

      user.collection_indexed = true
      users.save(user)

      notify(username: username, channel: channel) if channel.to_s.present?
      true
    end

    private

    ##
    # @param [Entities::User] user
    # @param [Integer] tries
    #
    def lookup(user:, tries: 1)
      ::BggApi.collection(user.bgg_username, subtype: 'boardgame', excludesubtype: 'boardgameexpansion')
    rescue StandardError || RuntimeError => e
      if e.message.include?('202')
        raise if tries > 10
        logger.info "Received a 202 from BGG for #{user.bgg_username}, sleeping 3s and trying again"
        sleep 3
        lookup(user: user, tries: tries + 1 )
      else
        raise
      end
    end

    ##
    # Store the game record with metadata
    #
    def persist_game(item:)
      bgg_game = ::Bgg::Game.find_by_id(item.id)
      raise "Game not found with id: #{item.id}" unless bgg_game

      game = ::Game.create!(
        bgg_id: bgg_game.id,
        name: bgg_game.name,
        description: HTMLEntities.new.decode(bgg_game.description),
        year_published: bgg_game.year_published,
        min_players: bgg_game.min_players.to_i,
        max_players: bgg_game.max_players.to_i,
        min_playtime: bgg_game.min_playtime.to_i,
        max_playtime: bgg_game.max_playtime.to_i,
        min_age: bgg_game.recommended_minimum_age.to_i,
        image: bgg_game.image,
        thumbnail: bgg_game.thumbnail,
        board_game_rank: bgg_game.stats.board_game_rank == 'N/A' ? 0 : bgg_game.stats.board_game_rank,
        strategic_rank: bgg_game.stats.strategic_rank == 'N/A' ? 0 : bgg_game.stats.strategic_rank,
        thematic_rank: bgg_game.stats.thematic_rank == 'N/A' ? 0 : bgg_game.stats.thematic_rank,
        average_rating: bgg_game.stats.average_rating,
        users_rated: bgg_game.stats.users_rated,
        owners: bgg_game.stats.owners,
        mechanics: bgg_game.mechanics.join(', ')
      )

      game.to_entity
    rescue StandardError => e
      logger.error "-- Could not index game: #{item.name} - #{item.id}: #{e.message}"
    end

    ##
    # Store user statistics for the game
    #
    def persist_user_game(game:, item:, user:)
      ::UserGame.create!(
        user_id: user.id,
        game_id: game.id,
        owned: item.owned?,
        user_rating: item.user_rating.to_i,
        play_count: item.play_count.to_i,
        for_trade: item.for_trade?,
        want_to_buy: item.want_to_buy?,
        want_to_play: item.want_to_play?
      )
    end

    ##
    # Notify channel we're finished
    #
    def notify(username:, channel:)
      slack.chat_postMessage(channel: channel, text: "BGG collection indexing finished for #{username}", as_user: true)
    end
  end
end
