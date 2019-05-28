class Game < ApplicationRecord
  scope :with_name, ->(name) { where(name: name) }
  scope :with_bgg_id, ->(bgg_id) { where(bgg_id: bgg_id) }

  has_many :user_games
  has_many :users, through: :user_games

  validates_presence_of :name, :bgg_id

  def to_entity
    Entities::Game.new(
      id: id,
      bgg_id: bgg_id,
      name: name,
      description: description,
      year_published: year_published,
      min_players: min_players.to_i,
      max_players: max_players.to_i,
      min_playtime: min_playtime.to_i,
      max_playtime: max_playtime.to_i,
      min_age: min_age.to_i,
      image: image,
      thumbnail: thumbnail,
      board_game_rank: board_game_rank,
      strategic_rank: strategic_rank,
      thematic_rank: thematic_rank,
      average_rating: average_rating,
      users_rated: users_rated,
      owners: owners,
      mechanics: mechanics.split(',')
    )
  end
end
