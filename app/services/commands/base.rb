require 'users/errors'

module Commands
  class Base < ::SlackRubyBot::Commands::Base
    attr_accessor :client
    attr_accessor :data
    attr_accessor :user
    attr_reader :obj_user
    attr_accessor :match

    def initialize(client, data, match)
      @client = client
      @data = data
      @match = match
      @users_repository = App['users.repository']
      user
    end

    def user
      unless @user.present?
        raise Users::Errors::UserNotFound, 'No user present in base command data' unless data.user
        @user = @users_repository.find_by_slack_id(data.user)
        raise Users::Errors::UserNotFound, "User not found with ID: #{data.user}" unless @user.present?
      end
      @user
    end

    def call
      raise NotImplementedError
    end

    def self.help(cmd, syntax: '', description: '')
      SlackRubyBot::CommandsHelper.instance.capture_help(self) do
        command(cmd) do
          desc(syntax)
          long_desc(description)
        end
      end
    end

    def self.on(type, pattern)
      send(type, pattern) do |client, data, match|
        service = self.new(client, data, match)
        service.call
      end
    end

    ##
    # @param [String] text
    # @param [Hash] options
    #
    def say(text, options = {})
      client.say({
        channel: data.channel,
        text: text
      }.merge(options))
    end

    def channel
      data.channel
    end

    def expression
      match[:expression].to_s
    end

    def logger
      SlackRubyBot::Client.logger
    end
  end
end
