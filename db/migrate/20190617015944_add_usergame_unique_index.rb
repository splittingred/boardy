class AddUsergameUniqueIndex < ActiveRecord::Migration[5.2]
  def change
    remove_index :user_games, [:user_id, :game_id]
    add_index :user_games, [:user_id, :game_id], unique: true
  end
end
