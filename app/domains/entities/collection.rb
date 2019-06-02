# frozen_string_literal: true

module Entities
  ##
  # Represents a collection of entities, with a total attribute. Useful for iterating over entities
  # and providing more metadata around the collection
  #
  class Collection
    include Enumerable

    attr_reader :entities
    attr_reader :total

    ##
    # @param [Array] entities
    # @param [Integer] total
    #
    def initialize(entities:, total:)
      @entities = entities
      @total = total
    end

    ##
    # Iterate over all the entities with the given block
    #
    def each(&block)
      @entities.each(&block)
    end
  end
end
