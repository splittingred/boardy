class AddUserGames < ActiveRecord::Migration[5.2]
  def change
    create_table :user_games do |t|
      t.references :user
      t.references :game
      t.boolean :owned, default: false
      t.float :user_rating, default: 0.0
      t.integer :play_count, default: 0
      t.boolean :for_trade, default: false
      t.boolean :want_to_buy, default: false
      t.boolean :want_to_play, default: false
    end

    add_index :user_games, [:user_id, :game_id]
  end
end
