module Entities
  class User < Entities::Base
    attribute :id, Types::Integer
    attribute :bgg_username, Types::String
    attribute :slack_username, Types::String
    attribute :slack_id, Types::String
    attribute :slack_team_id, Types::String
    attribute :email, Types::String
    attribute :first_name, Types::String
    attribute :last_name, Types::String
    attribute :title, Types::String
    attribute :created_at, Types::DateTime
    attribute :updated_at, Types::DateTime.optional

    def initialize(attributes = {})
      super(attributes)
      self.slack_username = email.split('@').first if email.to_s.present? && !slack_username.to_s.present?
    end

    ##
    # @return [String]
    #
    def at
      "<@#{slack_id}>"
    end
  end
end
