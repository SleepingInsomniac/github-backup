
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "github_backup/version"

Gem::Specification.new do |spec|
  spec.name          = "github_backup"
  spec.version       = GithubBackup::VERSION
  spec.authors       = ["Alex Clink"]
  spec.email         = ["hello@alexclink.com"]

  spec.summary       = "Create backups of your github repos"
  spec.description   = "Automatically clones your github repos and makes git bundles"
  spec.homepage      = "https://github.com/SleepingInsomniac/github-backup"

  spec.metadata      = {
    "source_code_uri" => "https://github.com/SleepingInsomniac/github-backup"
  }

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "link_header"
  spec.add_dependency "http"
end
