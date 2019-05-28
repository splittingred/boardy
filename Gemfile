source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'bgg', git: 'https://github.com/carmstrong/bgg.git'
gem 'celluloid-io'
gem 'dry-system', '~> 0.10.1'
gem 'dry-types', '~> 0.13.2'
gem 'faraday'
gem 'foreman'
gem 'hashie'
gem 'htmlentities'
gem 'mysql2'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.4'
gem 'redis'
gem 'resque'
gem 'settingslogic'
gem 'slack-ruby-bot'

# assets
gem 'jbuilder', '~> 2.5'
gem 'sass-rails', '~> 5.0'

group :development, :test do
  gem 'better_errors', '~> 2.1.1'
  gem 'binding_of_caller', '~> 0.7.2'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'dotenv-rails'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :production, :staging, :integration do
  gem 'rails_12factor'
end
