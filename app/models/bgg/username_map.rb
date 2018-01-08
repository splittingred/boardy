require 'yaml'

module Bgg
  ##
  # Translates usernames based on custom map
  #
  class UsernameMap
    def initialize
      @users = load || {}
    end

    ##
    # @param [String]
    # @return [String]
    #
    def translate(username)
      @users.fetch(username.to_s.downcase.to_sym, username)
    end

    private

    def load
      return unless file_exists?

      users = {}
      data = YAML.load(File.read(file_path)).deep_symbolize_keys
      data[:users].each do |u|
        ux = u.split(':')
        users[ux[0].to_sym] = ux[1]
      end
      users
    end

    def file_exists?
      File.exist?(file_path)
    end

    def file_path
      "#{Rails.root}/config/users.yml"
    end
  end
end
