require 'resque/tasks'
require 'resque-scheduler'
require 'resque/scheduler/tasks'
require 'active_scheduler'

namespace :resque do
  task setup: :environment do
    Resque.before_fork = Proc.new do |_job|
      ActiveRecord::Base.connection.disconnect!
    end
    Resque.after_fork = Proc.new do |_job|
      ActiveRecord::Base.establish_connection
    end
  end

  task setup_schedule: :setup do
    require 'resque-scheduler'
    Resque::Scheduler.dynamic = true
    Resque.schedule = ActiveScheduler::ResqueWrapper.wrap(YAML.load_file("#{Rails.root}/config/resque-schedule.yml"))
  end

  task scheduler: :setup_schedule
end
