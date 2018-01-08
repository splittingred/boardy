module Commands
  module Bgg
    class Collection < ::Commands::Base
      on :command, 'bgg collection'

      def call
        result = ::BggApi.collection(expression)
        say "#{expression} has #{result.count} games."
      end
    end
  end
end

