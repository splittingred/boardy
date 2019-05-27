class AddGame < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.integer :bgg_id, index: true
      t.string :name, limit: 255, index: true
      t.text :description
      t.string :year_published, limit: 10, default: '1900'
      t.integer :min_players, default: 0, index: true
      t.integer :max_players, default: 1, index: true
      t.integer :min_playtime, default: 0, index: true
      t.integer :max_playtime, default: 0, index: true
      t.integer :min_age, default: 0, index: true
      t.string :thumbnail
      t.string :image
      t.integer :users_rated, default: 0
      t.integer :owners, default: 0
      t.integer :board_game_rank, default: 0, index: true
      t.integer :strategic_rank, default: 0, index: true
      t.integer :thematic_rank, default: 0, index: true
      t.float :average_rating, default: 0.0, index: true
      t.text :mechanics
    end
  end
end
