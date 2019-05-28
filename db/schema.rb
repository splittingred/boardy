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

ActiveRecord::Schema.define(version: 20190528003050) do

  create_table "games", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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
    t.float "average_rating", limit: 24, default: 0.0
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

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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
    t.index ["bgg_username"], name: "index_users_on_bgg_username"
    t.index ["email"], name: "index_users_on_email"
    t.index ["slack_id"], name: "index_users_on_slack_id"
  end

end
