require 'json'
require 'fileutils'

module GithubBackup
  class JSONStore
    def initialize(path)
      @path = path
      FileUtils.mkdir_p(File.dirname(@path))
    end

    def data
      @data || load!
    end

    def load!
      @data = exists? ? JSON.parse(File.read(@path)) : {}
      @data['_read_at'] = Time.now
      @data
    end

    def exists?
      File.exist?(@path)
    end

    def [](key)
      data[key]
    end

    def []=(key, value)
      data[key] = value
    end

    def save
      return false unless @data
      @data['_saved_at'] = Time.now
      File.open(@path, 'w') do |file|
        file.write(to_s)
      end
      true
    end

    def delete!
      File.unlink(@path) if File.exist?(@path)
    end

    def to_s
      JSON.pretty_generate(data)
    end
  end
end
