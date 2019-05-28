module Commands
  module Users
    class MapBggUsername < ::Commands::Base
      on :command, 'set bgg username to'

      def call
        name = expression.split(' ').first
        user.bgg_username = name
        users.save(user)
        say "Mapped your BGG username to #{name}"
      end
    end
  end
end

