require_relative 'lib/surrealdb/version'

Gem::Specification.new do |spec|
  spec.name          = "surrealdb"
  spec.version       = Surrealdb::VERSION
  spec.authors       = ["Sam Kenney"]

  spec.summary       = "Ruby driver for SurrealDB"
  spec.homepage      = "https://surrealdb.com/docs/integration/libraries/ruby"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.4")

  spec.licenses = ["MIT"]

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/sam-kenney/surrealdb.rb/"
  spec.metadata["changelog_uri"] = "https://github.com/sam-kenney/surrealdb.rb/"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
