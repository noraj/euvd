# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

require 'bundler/setup'
require 'euvd'
require 'webmock/rspec'

RSpec.configure do |c|
  c.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  c.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  c.disable_monkey_patching!
  c.order = :defined
end
