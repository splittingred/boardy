# frozen_string_literal: true

require 'htmlentities'

module Games
  class Service
    include ::Boardy::Import[
      logger: 'logger'
    ]

    def find(id)
      game = ::Game.find_by_bgg_id!(id)
      game.to_entity
    rescue ActiveRecord::RecordNotFound => _e
      bgg_game = ::Bgg::Game.find_by_id(id)
      map_game(bgg_game).to_entity
    rescue StandardError || RuntimeError => e
      raise ::Games::Errors::ResultProcessing if e.message.include?('202')
      logger.error "Error loading game: #{e.message} - #{e.backtrace[0..4].join("\n")}"
      raise
    end

    ##
    # @return [Entities::Game]
    #
    def find_by_name(name)
      game = load(name)
      unless game
        result = ::BggApi.search(name, type: 'boardgame', exact: true, stats: 1)
        if result && (result.first.nil? || result.xml.xpath('errors/error/message').children.first.to_s.present?)
          raise Games::Errors::GameNotFound, "Game not found with name #{name}"
        end

        game = map_game(result.first.game)
        raise Games::Errors::GameNotFound, "Game not found with name: #{name}" unless game
      end
      game.to_entity
    rescue StandardError || RuntimeError => e
      raise Games::Errors::ResultProcessing if e.message.include?('202')
      logger.error "Error loading game: #{e.message}"
      raise
    end

    ##
    # @param [String] user
    # @param [String] game
    # @return [Bgg::Result::SearchItem|FalseClass]
    #
    def user_has_game?(user:, game:)
      game = game.to_s.downcase

      collection = ::BggApi.collection(user)
      raise StandardError, 'Empty response from boardgamegeek' unless collection

      error = collection.xml.xpath('errors/error/message').children.first.to_s
      raise StandardError, error if error.present?

      result = collection.select { |g| g.name.to_s.downcase.include?(game) }.first
      result ? result : false
    rescue StandardError || RuntimeError => e
      raise Games::Errors::ResultProcessing if e.message.include?('202')
      logger.error "Error loading game: #{e.message}"
      raise
    end

    ##
    # @param [String] user
    #
    def user_collection(user)
      ::BggApi.collection(user, subtype: 'boardgame')
    rescue StandardError || RuntimeError => e
      raise Games::Errors::ResultProcessing if e.message.include?('202')
      logger.error "Error loading collection: #{e.message}"
      raise
    end

    ##
    # @param [Integer] start
    # @param [Integer] limit
    # @return [Entities::Collection<Entities::Game>]
    #
    def list(start: 0, limit: 10)
      total = ::Game.count
      games = ::Game.order(name: :asc).offset(start).limit(limit)
      Entities::Collection.new(
        entities: games.map(&:to_entity),
        total: total
      )
    end

    private

    def load(name)
      ::Game.with_name(name).first
    end

    def map_game(game)
      result = ::BggApi.thing(id: game.id, type: 'boardgame')
      result = result.deep_symbolize_keys[:item].first

      ::Game.create!(
        bgg_id: game.id,
        name: game.name,
        description: HTMLEntities.new.decode(game.description),
        year_published: game.year_published,
        min_players: game.min_players.to_i,
        max_players: game.max_players.to_i,
        min_playtime: result[:minplaytime].first[:value].to_i,
        max_playtime: result[:maxplaytime].first[:value].to_i,
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
    end
  end
end
