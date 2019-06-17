# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_06_17_015944) do

  create_table "games", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "bgg_id"
    t.string "name"
    t.text "description"
    t.string "year_published", limit: 10, default: "1900"
    t.integer "min_players", default: 0
    t.integer "max_players", default: 1
    t.integer "min_playtime", default: 0
    t.integer "max_playtime", default: 0
    t.integer "min_age", default: 0
    t.string "thumbnail"
    t.string "image"
    t.integer "users_rated", default: 0
    t.integer "owners", default: 0
    t.integer "board_game_rank", default: 0
    t.integer "strategic_rank", default: 0
    t.integer "thematic_rank", default: 0
    t.float "average_rating", default: 0.0
    t.text "mechanics"
    t.index ["average_rating"], name: "index_games_on_average_rating"
    t.index ["bgg_id"], name: "index_games_on_bgg_id"
    t.index ["board_game_rank"], name: "index_games_on_board_game_rank"
    t.index ["max_players"], name: "index_games_on_max_players"
    t.index ["max_playtime"], name: "index_games_on_max_playtime"
    t.index ["min_age"], name: "index_games_on_min_age"
    t.index ["min_players"], name: "index_games_on_min_players"
    t.index ["min_playtime"], name: "index_games_on_min_playtime"
    t.index ["name"], name: "index_games_on_name"
    t.index ["strategic_rank"], name: "index_games_on_strategic_rank"
    t.index ["thematic_rank"], name: "index_games_on_thematic_rank"
  end

  create_table "user_games", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "game_id"
    t.boolean "owned", default: false
    t.float "user_rating", default: 0.0
    t.integer "play_count", default: 0
    t.boolean "for_trade", default: false
    t.boolean "want_to_buy", default: false
    t.boolean "want_to_play", default: false
    t.index ["game_id"], name: "index_user_games_on_game_id"
    t.index ["user_id", "game_id"], name: "index_user_games_on_user_id_and_game_id", unique: true
    t.index ["user_id"], name: "index_user_games_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "bgg_username"
    t.string "slack_id"
    t.string "slack_team_id"
    t.string "slack_username"
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "collection_indexed", default: false
    t.index ["bgg_username"], name: "index_users_on_bgg_username"
    t.index ["email"], name: "index_users_on_email"
    t.index ["slack_id"], name: "index_users_on_slack_id"
  end

end
