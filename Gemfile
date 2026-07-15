# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

# Needed for the library
group :runtime, :all do
  gem 'faraday', '>= 1.0', '< 3'
  gem 'sawyer', '~> 0.9'
end

# Needed to install dependencies
group :development, :install do
  gem 'bundler', '~> 4.0'
end

# Needed to run tests, specs, coverage
group :development, :test do
  gem 'rake', '~> 13.0'
  gem 'rspec', '~> 3.12'
  gem 'simplecov', '~> 0.22'
  gem 'webmock', '~> 3.19'
end

# Needed for linting
group :development, :lint do
  gem 'rubocop', '~> 1.88'
end

# Needed for documentation
group :development, :docs do
  gem 'commonmarker', '~> 2.9' # for markdown support in YARD
  gem 'webrick', '~> 1.9' # for yard server
  gem 'yard', ['>= 0.9.43', '< 0.10']
  gem 'yard-coderay', '~> 0.1' # for syntax highlight support in YARD
end

# Needed for debugging
group :development, :debug do
  gem 'irb', '>= 1.18'
end
