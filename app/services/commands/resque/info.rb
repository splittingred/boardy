module Commands
  module Resque
    class Info < ::Commands::Base
      on :command, 'resque info'

      include ::Import[
        redis: 'redis'
      ]

      def call
        info = ::Resque.info

        say "Jobs Report:
```
* Pending: #{info[:pending]}
* Processed: #{info[:processed]}
* Failed: #{info[:failed]}
* Queues: #{info[:queues]}
* Workers: #{info[:workers]}
* Working: #{info[:working]}
```"
      end
    end
  end
end

