# frozen_string_literal: true

require 'sawyer'

module EUVD
  class Error < StandardError; end
  class NotFoundError < Error; end
  class RateLimitError < Error; end
  class ServerError < Error; end
  class BadResponseError < Error; end

  class Client
    BASE_URL = 'https://euvdservices.enisa.europa.eu/api'

    attr_reader :base_url, :agent

    def initialize(options = {})
      @base_url = options[:base_url] || BASE_URL
      @agent = build_agent
    end

    # GET request returning parsed response data.
    #
    # @param path [String] API path (e.g. 'lastvulnerabilities')
    # @param params [Hash] Query parameters
    # @return [Sawyer::Resource, Array, String] parsed data
    def get(path, params = {})
      response = @agent.call(:get, path, nil, query: params)
      response = handle_status(response)
      validate_content_type!(response)
      response.data
    end

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

    def inspect
      format('#<%<class_name>s:0x%<object_id>x %<url>s>',
             class_name: self.class,
             object_id: object_id * 2,
             url: @base_url)
    end

    private

    def build_agent
      conn = Faraday.new(url: @base_url) do |b|
        b.request :url_encoded
        b.adapter Faraday.default_adapter
      end

      Sawyer::Agent.new(@base_url, faraday: conn) do |http|
        http.headers['Accept'] = 'application/json'
        http.headers['User-Agent'] = "euvd-ruby/#{EUVD::VERSION}"
      end
    end

    def handle_status(response)
      case response.status
      when 200..299
        response
      when 404
        raise NotFoundError, "Resource not found at #{response.env.url}"
      when 429
        raise RateLimitError, 'API rate limit exceeded'
      when 500..599
        raise ServerError, "Server error (#{response.status})"
      else
        raise Error, "Unexpected response (#{response.status})"
      end
    end

    def validate_content_type!(response)
      ct = response.headers['content-type'].to_s
      allowed = %w[application/json application/problem+json text/csv text/plain]
      return if allowed.any? { |t| ct.include?(t) }

      snippet = response.body.to_s.gsub(/\s+/, ' ').strip[0..120]
      raise BadResponseError, "Expected JSON/text but got '#{ct}' (HTTP #{response.status}): #{snippet.inspect}"
    end
  end
end
