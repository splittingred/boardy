class User < ApplicationRecord
  scope :with_email, -> (email) { where(email: email) }
  scope :with_slack_id, -> (slack_id) { where(slack_id: slack_id) }

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
end
