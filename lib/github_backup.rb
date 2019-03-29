module GithubBackup
  class Error < StandardError; end
end

require "github_backup/version"
require 'github_backup/api'
require 'github_backup/config'
require 'github_backup/helpers'
