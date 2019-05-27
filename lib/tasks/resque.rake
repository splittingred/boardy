require 'resque/tasks'

namespace :resque do
  task setup: :environment do
    require 'resque'
    ENV['QUEUE'] = '*'

    data = { url: ENV.fetch('REDIS_URL', 'localhost:6379').to_s }
    pw = ENV.fetch('REDIS_PASSWORD', '').to_s
    data[:password] = pw if pw.present?
    Resque.redis = data
  end
end

Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }
