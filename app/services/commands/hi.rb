module Commands
  class Hi < ::Commands::Base
    on :command, 'hi'

    def call
      say "Hello! How can I help?"
    end
  end
end

