module Users
  module Errors
    class Base < StandardError; end
    class UserNotFound < Base; end
  end
end
