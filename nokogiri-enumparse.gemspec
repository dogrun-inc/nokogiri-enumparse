# frozen_string_literal: true

require_relative "lib/nokogiri/enumparse/version"

Gem::Specification.new do |spec|
  spec.name = "nokogiri-enumparse"
  spec.version = Nokogiri::XML::Enumparse::VERSION
  spec.authors = ["constdrop"]
  spec.email = ["hirota@dogrun.jp"]

  spec.summary = "Lazy loading XML parser with Nokogiri."
  # spec.description = "TODO: Write a longer description or delete this line."
  spec.homepage = "https://github.com/dogrun-inc/nokogiri-enumparse"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/dogrun-inc/nokogiri-enumparse"
  spec.metadata["changelog_uri"] = "https://github.com/dogrun-inc/nokogiri-enumparse/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "nokogiri", ">= 1.14.4"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
