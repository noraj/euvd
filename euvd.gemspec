# frozen_string_literal: true

require_relative 'lib/euvd/version'

Gem::Specification.new do |spec|
  spec.name          = 'euvd'
  spec.version       = EUVD::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ['Alexandre ZANNI']
  spec.email         = 'alexandre.zanni@europe.com'
  spec.summary       = 'Ruby wrapper for the European Union Vulnerability Database (EUVD) API'
  spec.description   = 'A Ruby client library for the EUVD (European Union Vulnerability Database) API. ' \
                       'Provides a convenient interface to search and retrieve ' \
                       'vulnerability information, CVEs, CPEs, CWEs, CAPECs, and advisories.'
  spec.homepage      = 'https://github.com/noraj/euvd'
  spec.licenses      = ['MIT']

  spec.required_ruby_version = ['>= 3.3.0', '< 5.0']

  spec.metadata = {
    'yard.run' => 'yard',
    'bug_tracker_uri' => 'https://github.com/noraj/euvd/issues',
    'changelog_uri' => 'https://github.com/noraj/euvd/releases',
    'documentation_uri' => 'https://noraj.github.io/euvd/',
    'homepage_uri' => 'https://github.com/noraj/euvd',
    'source_code_uri' => 'https://github.com/noraj/euvd/',
    'rubygems_mfa_required' => 'true'
  }

  spec.add_runtime_dependency 'faraday', '>= 1.0', '< 3'
  spec.add_runtime_dependency 'sawyer', '~> 0.9'

  spec.files = Dir['lib/**/*.rb'] + %w[README.md LICENSE]
  spec.require_paths = ['lib']
end
