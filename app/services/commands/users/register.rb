require 'users/errors'

module Commands
  module Users
    class Register < ::Commands::Base
      on :match, /register (.*) bgg (.*)/i

      def call
        slack_id = unescape_string(match[1].to_s).delete('@')
        bgg_username = match[2].to_s

        user = users.find_by_slack_id(slack_id)
        user.bgg_username = bgg_username
        user = users.save(user)

        say "#{user.slack_username} has been registered with BGG username #{user.bgg_username}"
      end
    end
  end
end

