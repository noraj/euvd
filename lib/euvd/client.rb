# frozen_string_literal: true

require 'sawyer'

module EUVD
  # Error base class for all EUVD client errors.
  class Error < StandardError; end

  # Raised when the API returns a non-JSON response (e.g. HTML error page).
  class BadResponseError < Error; end

  # Raised when a resource is not found (HTTP 404).
  class NotFoundError < Error; end

  # Raised when the API rate limit is exceeded (HTTP 429).
  class RateLimitError < Error; end

  # Raised when the API returns a server error (HTTP 5xx).
  class ServerError < Error; end

  # Client for the EUVD API.
  #
  # All endpoints are GET-only and require no authentication.
  # JSON responses are returned as rich +Sawyer::Resource+ objects
  # (or Array of them), so you can access fields as methods
  # instead of hash keys.
  class Client
    BASE_URL = 'https://euvdservices.enisa.europa.eu/api'

    attr_reader :base_url, :agent

    # @param options [Hash]
    # @option options [String] :base_url API base URL (default: EUVD::Client::BASE_URL)
    def initialize(options = {})
      @base_url = options[:base_url] || BASE_URL
      @agent = build_agent
    end

    # Make a GET request and return parsed response data.
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

    # @return [EUVD::API::Vulnerabilities]
    def vulnerabilities
      API::Vulnerabilities.new(self)
    end

    # @return [EUVD::API::Records]
    def records
      API::Records.new(self)
    end

    # @return [EUVD::API::Downloads]
    def downloads
      API::Downloads.new(self)
    end

    # @return [EUVD::API::Meta]
    def meta
      API::Meta.new(self)
    end

    # @return [EUVD::API::Observations]
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
