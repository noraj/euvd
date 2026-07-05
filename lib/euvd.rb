# frozen_string_literal: true

require_relative 'euvd/version'
require_relative 'euvd/client'
require_relative 'euvd/api/vulnerabilities'
require_relative 'euvd/api/records'
require_relative 'euvd/api/downloads'
require_relative 'euvd/api/meta'
require_relative 'euvd/api/observations'

module EUVD
  class Client
    def vulnerabilities
      API::Vulnerabilities.new(self)
    end

    def records
      API::Records.new(self)
    end

    def downloads
      API::Downloads.new(self)
    end

    def meta
      API::Meta.new(self)
    end

    def observations
      API::Observations.new(self)
    end
  end
end
