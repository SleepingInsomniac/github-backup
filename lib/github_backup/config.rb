require 'json'
require 'fileutils'
require 'github_backup/json_store'

module GithubBackup
  class Config
    attr_accessor :override

    def initialize(default_path)
      @override = {}
      @default_path = default_path
    end

    def defaults
      if @default_path
        @defaults ||= JSONStore.new(@default_path)
      else
        {}
      end
    end

    def values
      @values ||= JSONStore.new(path)
    end

    def data
      @data ||= JSONStore.new(data_path)
    end

    # Check if the config exists
    def exists?
      values.exists?
    end

    # The user's home directory
    def home
      ENV['HOME'] || File.expand_path('~')
    end

    # The user's preferred config dir
    def dir
      ENV['XDG_CONFIG_HOME'] || File.join(home, '.config')
    end

    def data_dir
      ENV['XDG_DATA_HOME'] || File.join(home, '.local', 'share')
    end

    def data_path
      File.join(data_dir, "#{APP}.json")
    end

    # the path to the config file
    def path
      File.join(dir, "#{APP}.json")
    end

    # Read a value from the config ex:
    # config[key] # => value
    def [](key)
      @override[key] || values[key] || defaults[key]
    end

    # Set a value in the config ex:
    # config[key] = value
    def []=(key, value)
      values[key] = value
      values.save
    end

    # Write config to disk at the user's config dir.
    # Doesn't save overrides
    def save
      values.save
    end

    # Removes the saved config
    def delete!
      values.delete!
    end

    # writes the config json to stdout
    def to_s
      values.to_s
    end
  end
end
