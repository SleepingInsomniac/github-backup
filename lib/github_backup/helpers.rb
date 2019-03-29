require 'fileutils'

module GithubBackup
  module Helpers
    def inside(dir)
      current = Dir.pwd
      chdir_p dir
      yield
      Dir.chdir(current)
    end

    def chdir_p(path)
      FileUtils.mkdir_p path
      Dir.chdir path
    end
  end
end
