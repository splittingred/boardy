require 'resque'
ENV['QUEUE'] = '*'

data = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379').to_s }
pw = ENV.fetch('REDIS_PASSWORD', '').to_s
data[:password] = pw if pw.present?
Resque.redis = data

Resque.logger.level = Logger::INFO
