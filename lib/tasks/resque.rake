require 'resque/tasks'

namespace :resque do
  task setup: :environment do
  end
end

Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }
