class UserGame < ApplicationRecord
  belongs_to :user
  belongs_to :game

  def to_entity
    Entities::UserGame.new(
      game_id: game_id.to_i,
      user_id: user_id.to_i,
      owned: owned?,
      user_rating: user_rating,
      play_count: play_count.to_i,
      for_trade: for_trade?,
      want_to_buy: want_to_buy?,
      want_to_play: want_to_play?
    )
  end
end
