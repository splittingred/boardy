module Commands
  module Bgg
    class Collection < ::Commands::Base
      on :command, 'bgg collection'

      def call
        result = ::BggApi.collection(expression)
        say result.inspect
      end
    end
  end
end

