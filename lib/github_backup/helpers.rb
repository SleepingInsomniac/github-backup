require 'fileutils'

module GithubBackup
  module Helpers
    def inside(dir)
      current = Dir.pwd
      FileUtils.mkdir_p(dir)
      Dir.chdir(dir)
      yield
      Dir.chdir(current)
    end
  end
end
