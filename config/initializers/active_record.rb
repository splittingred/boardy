Rails.application.config.before_fork_callbacks << lambda do
  ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
end

Rails.application.config.on_worker_boot_callbacks << lambda do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
