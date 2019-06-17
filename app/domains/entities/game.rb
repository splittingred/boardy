module Entities
  class Game < Entities::Base
    attribute :id,              Types::Integer
    attribute :bgg_id,          Types::Integer
    attribute :name,            Types::String
    attribute :description,     Types::String
    attribute :year_published,  Types::Integer
    attribute :min_players,     Types::Integer
    attribute :max_players,     Types::Integer
    attribute :min_playtime,    Types::Integer
    attribute :max_playtime,    Types::Integer
    attribute :min_age,         Types::Integer
    attribute :image,           Types::String
    attribute :thumbnail,       Types::String
    attribute :board_game_rank, Types::Integer
    attribute :strategic_rank,  Types::Integer
    attribute :thematic_rank,   Types::Integer
    attribute :average_rating,  Types::Float
    attribute :users_rated,     Types::Integer
    attribute :owners,          Types::Integer
    attribute :mechanics,       Types::Array.of(Types::String)
    attribute :owned_by,        Types::Array.of(Types::String)
    attribute :created_at,      Types::DateTime.optional
    attribute :updated_at,      Types::DateTime.optional
  end
end
