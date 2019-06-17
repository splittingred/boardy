threads_count = ENV.fetch('RAILS_MAX_THREADS', 5)
threads threads_count, threads_count

port ENV.fetch('PORT', 4010)

environment ENV.fetch('RAILS_ENV', 'development')

workers ENV.fetch('WEB_CONCURRENCY', 2)

preload_app!

plugin :tmp_restart
tag 'boardy'
rackup DefaultRackup # Set to use config.ru
clean_thread_locals(ENV.fetch('PUMA_CLEAN_THREAD_LOCALS', 1).to_i.positive?)

# callbacks
before_fork do
  Rails.application.config.before_fork_callbacks.each(&:call)
end

on_worker_boot do
  Rails.application.config.on_worker_boot_callbacks.each(&:call)
end

after_worker_fork do
  Rails.application.config.after_fork_callbacks.each(&:call)
end
