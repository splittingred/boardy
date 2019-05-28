module Entities
  class UserGame < Entities::Base
    attribute :game_id,           Types::Integer
    attribute :game_name,         Types::String
    attribute :game_bgg_id,       Types::Integer
    attribute :user_id,           Types::Integer
    attribute :owned,             Types::Bool
    attribute :user_rating,       Types::Float
    attribute :play_count,        Types::Integer
    attribute :for_trade,         Types::Bool
    attribute :want_to_buy,       Types::Bool
    attribute :want_to_play,      Types::Bool
  end
end
