require 'dry/system/container'

class App < Dry::System::Container
  configure do |config|
    config.root = ::Rails.root
    config.name = :boardy
    config.auto_register = %w[app/domains]
  end

  load_paths!('lib', 'app', 'app/domains')

  register 'logger', Rails.logger
end

Import = App.injector
App.finalize! if Rails.env.production?
