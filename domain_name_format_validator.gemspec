# frozen_string_literal: true

require_relative "lib/domain_name_format_validator/version"

Gem::Specification.new do |gem|
  gem.name        = "domain_name_format_validator"
  gem.version     = DomainNameFormatValidator::VERSION
  gem.platform    = Gem::Platform::RUBY
  gem.authors     = ["David Keener", "Wolfgang Hotwagner"]
  gem.email       = ["code@feedyourhead.at"]
  gem.homepage    = "https://github.com/whotwagner/domain_name_format_validator"
  gem.summary     = "Domain Name Format Validator"
  gem.description = "Checks if the format of a domain name is valid."
  gem.license     = "MIT"
  gem.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  gem.metadata["source_code_uri"] = "https://github.com/whotwagner/domain_name_format_validator"

  gem.rubyforge_project = "domain_name_format_validator"

  gem.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.bindir        = "exe"
  gem.executables   = gem.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  gem.require_paths = ["lib"]
end
