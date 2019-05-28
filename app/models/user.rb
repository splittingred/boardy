class User < ApplicationRecord
  scope :with_email, -> (email) { where(email: email) }
  scope :with_bgg_username, -> (bgg_username) { where(bgg_username: bgg_username) }
  scope :with_slack_id, -> (slack_id) { where(slack_id: slack_id) }

  has_many :user_games
  has_many :games, through: :user_games

  ##
  # @param [Slack::Messages::Message] slack_user
  # @return [User]
  #
  def self.build_from_slack_user(slack_user)
    user = self.with_slack_id(slack_user.id).first_or_initialize
    user.slack_username = slack_user.name
    user.slack_team_id = slack_user.team_id
    user.email = slack_user.profile['email'] if slack_user['email'].present?
    user.first_name = slack_user.profile['first_name'] if slack_user.profile['first_name'].present?
    user.last_name = slack_user.profile['last_name'] if slack_user.profile['last_name'].present?
    user.title = slack_user.profile['title'] if slack_user.profile['title'].present?
    user
  end

  ##
  # @return [Entities::User]
  #
  def to_entity
    ugs = []
    user_games.joins(:game).includes(:game).references(:game).each do |ug|
      uge = ug.to_entity
      uge.game_name = ug.game.name
      uge.game_bgg_id = ug.game.bgg_id
      ugs << uge
    end
    ::Entities::User.new(
      slack_username: slack_username,
      slack_id: slack_id,
      slack_team_id: slack_team_id,
      bgg_username: bgg_username,
      id: id,
      email: email,
      first_name: first_name,
      last_name: last_name,
      title: title,
      collection_indexed: collection_indexed,
      games: ugs
    )
  end
end
