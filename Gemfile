# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'active_scheduler'
gem 'bgg', git: 'https://github.com/carmstrong/bgg.git'
gem 'celluloid-io'
gem 'dotenv-rails'
gem 'dry-system', '~> 0.10.1'
gem 'dry-types', '~> 0.13.2'
gem 'faraday'
gem 'foreman'
gem 'hashie'
gem 'htmlentities'
gem 'mysql2'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.2'
gem 'redis'
gem 'resque'
gem 'resque-scheduler'
gem 'settingslogic'

gem 'async-websocket',          '~> 0.8.0'
gem 'slack-ruby-bot',           '~> 0.12'
gem 'slack-ruby-client',        '~> 0.14'

# assets
gem 'jbuilder', '~> 2.5'
gem 'sass-rails', '~> 5.0'

group :development, :test do
  gem 'better_errors', '~> 2.1.1'
  gem 'binding_of_caller', '~> 0.7.2'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'pry', '>= 0.12'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :production, :staging, :integration do
  gem 'rails_12factor'
end
