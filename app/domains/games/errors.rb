module Games
  module Errors
    class Error < StandardError; end
    class GameNotFound < Error; end
    class ResultProcessing < StandardError; end
  end
end
