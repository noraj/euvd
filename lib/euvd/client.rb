# frozen_string_literal: true

require 'sawyer'

module EUVD
  class Error < StandardError; end
  class NotFoundError < Error; end
  class RateLimitError < Error; end
  class ServerError < Error; end

  class Client
    BASE_URL = 'https://euvd.enisa.europa.eu/api/v1/'

    MEDIA_TYPES = {
      json: 'application/json',
      xml: 'application/xml'
    }.freeze

    attr_reader :auto_paginate, :per_page, :agent

    def initialize(options = {})
      @auto_paginate = options.fetch(:auto_paginate, false)
      @per_page      = options.fetch(:per_page, 20)
      @base_url      = options[:base_url] || BASE_URL
      @media_type    = options[:media_type] || :json
      @default_headers = build_default_headers(options[:headers] || {})
      @agent = build_agent(options[:faraday] || {})
    end

    # Make a GET request to the API.
    #
    # @param path [String] API path (e.g., 'cve/CVE-2021-44228')
    # @param options [Hash] Query parameters and request options
    # @option options [Hash] :query URL query parameters
    # @option options [Hash] :headers Custom request headers
    # @return [Sawyer::Response]
    def get(path, options = {})
      options[:headers] ||= {}
      options[:headers] = @default_headers.merge(options[:headers])
      response = @agent.call(:get, path, nil, options)
      handle_response(response)
    end

    # Access API resource modules.

    # @return [EUVD::API::CVE]
    def cve
      API::CVE.new(self)
    end

    # @return [EUVD::API::CPE]
    def cpe
      API::CPE.new(self)
    end

    # @return [EUVD::API::CWE]
    def cwe
      API::CWE.new(self)
    end

    # @return [EUVD::API::CAPEC]
    def capec
      API::CAPEC.new(self)
    end

    # @return [EUVD::API::Advisory]
    def advisory
      API::Advisory.new(self)
    end

    # @return [EUVD::API::Statistics]
    def statistics
      API::Statistics.new(self)
    end

    # @return [EUVD::API::Search]
    def search
      API::Search.new(self)
    end

    # Fetch all pages of a paginated response automatically.
    #
    # @param path [String] API path
    # @param options [Hash] Query options (including :per_page, :page, etc.)
    # @yield [Sawyer::Resource] Each item across all pages
    # @return [Array<Sawyer::Resource>] All items from all pages
    def paginate(path, options = {}, &block)
      return paginate_with_block(path, options, &block) if block

      results = []
      page = options.delete(:page) || 1
      per_page = options.delete(:per_page) || @per_page

      loop do
        response = get(path, query: options.merge(page: page, per_page: per_page))
        data = response.data
        items = if data.is_a?(Array)
                  data
                else
                  (data.respond_to?(:_embedded) ? data._embedded : [data])
                end
        break if items.nil? || items.empty?

        results.concat(items)
        break if items.size < per_page

        page += 1
      end

      results
    end

    def inspect
      format('#<%<class_name>s:0x%<object_id>x @base_url=%<url>s>',
             class_name: self.class,
             object_id: object_id * 2,
             url: @base_url)
    end

    private

    def build_default_headers(extra_headers)
      {
        'Accept' => MEDIA_TYPES.fetch(@media_type, MEDIA_TYPES[:json]),
        'User-Agent' => "EUVD Ruby Gem v#{EUVD::VERSION}"
      }.merge(extra_headers)
    end

    def build_agent(faraday_options)
      conn = Faraday.new(url: @base_url, **faraday_options) do |builder|
        builder.request :url_encoded
        builder.adapter Faraday.default_adapter
        yield builder if block_given?
      end

      Sawyer::Agent.new(@base_url, faraday: conn) do |http|
        http.headers.update(@default_headers)
      end
    end

    def handle_response(response)
      case response.status
      when 200..299
        response
      when 404
        raise NotFoundError, "Resource not found at #{response.env.url}"
      when 429
        raise RateLimitError, 'API rate limit exceeded'
      when 500..599
        raise ServerError, "Server error (#{response.status}): #{response.body}"
      else
        raise Error, "Unexpected response (#{response.status}): #{response.body}"
      end
    end

    def paginate_with_block(path, options = {}, &block)
      page = options.delete(:page) || 1
      per_page = options.delete(:per_page) || @per_page

      loop do
        response = get(path, query: options.merge(page: page, per_page: per_page))
        data = response.data
        items = if data.is_a?(Array)
                  data
                else
                  (data.respond_to?(:_embedded) ? data._embedded : [data])
                end
        break if items.nil? || items.empty?

        items.each(&block)
        break if items.size < per_page

        page += 1
      end
    end
  end
end
