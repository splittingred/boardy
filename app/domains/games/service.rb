module Games
  class Service
    ##
    # @return [Bgg::Game]
    #
    def find_by_name(name)
      result = ::BggApi.search(name, type: 'boardgame', exact: true, stats: 1)
      if result && (result.first.nil? || result.xml.xpath('errors/error/message').children.first.to_s.present?)
        raise Games::Errors::GameNotFound, "Game not found with name #{name}"
      end

      result.first.game
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
      raise
    end

    ##
    # @param [String] user
    #
    def user_collection(user)
      ::BggApi.collection(user, subtype: 'boardgame')
    rescue StandardError || RuntimeError => e
      raise Games::Errors::ResultProcessing if e.message.include?('202')
      raise
    end
  end
end
