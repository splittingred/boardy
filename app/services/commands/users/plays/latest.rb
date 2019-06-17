require 'users/errors'
require 'games/errors'

module Commands
  module Users
    module Plays
      class Latest < ::Commands::Base
        on :command, 'recent plays'

        def call
          username = clean_slack_username(expression.to_s)
          user = users.find_by_usernames(username)
          unless user.collection_indexed?
            say "#{user.bgg_username} has not yet had their collection indexed."
            return
          end

          games = plays.plays(user: user).to_a[0..4]

          out = []
          out << "#{user.bgg_username} last played:" if games.any?

          games.each do |play|
            if play.players
              players = play.players.map do |p|
                color = p.color.to_s.present? ? " as #{p.color}" : ''
                score = p.score.to_i.positive? ? " with score #{p.score}" : ''
                "#{p.name}#{score}#{color}"
              end
              players = "with #{players.join(', ')}"
              winners = play.players.select(&:winner?).map(&:name)
              winners = winners.any? ? " - Winners: _#{winners.join(', ')}_" : ''
            else
              players = ''
              winners = ''
            end
            out << "* _#{play.date}_ - *#{play.name}* #{players}#{winners}"
          end

          if games.any?
            say out.join("\n")
          else
            say "#{user.bgg_username} has not recorded any played games. :cry:"
          end
        rescue ::Users::Errors::UserNotFound => _e
          say "No user with username #{username} has been registered to Boardy yet."
        end

        private

        def plays
          @plays ||= Boardy::Container['users.plays.service']
        end
      end
    end
  end
end

