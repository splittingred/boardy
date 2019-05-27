require 'resque/tasks'

namespace :resque do
  task setup: :environment do
    Resque.before_fork = Proc.new do |_job|
      ActiveRecord::Base.connection.disconnect!
    end
    Resque.after_fork = Proc.new do |_job|
      ActiveRecord::Base.establish_connection
    end
  end
end
