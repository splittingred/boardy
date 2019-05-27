require 'resque/tasks'

namespace :resque do
  task setup: :environment do
    require 'resque'
    ENV['QUEUE'] = '*'

    Resque.redis = ENV.fetch('REDIS_URL', 'localhost:6379').to_s
  end
end

Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }
