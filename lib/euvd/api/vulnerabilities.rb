# frozen_string_literal: true

module EUVD
  module API
    # Access to vulnerability endpoints: latest, critical, exploited, and search.
    class Vulnerabilities
      def initialize(client)
        @client = client
      end

      # GET /api/lastvulnerabilities
      # Returns the latest vulnerabilities (maximum 8 records).
      #
      # @return [Array<Sawyer::Resource>]
      def latest
        @client.get('lastvulnerabilities')
      end

      # GET /api/exploitedvulnerabilities
      # Returns the latest exploited vulnerabilities (maximum 8 records).
      #
      # @return [Array<Sawyer::Resource>]
      def exploited
        @client.get('exploitedvulnerabilities')
      end

      # GET /api/criticalvulnerabilities
      # Returns the latest critical vulnerabilities (maximum 8 records).
      #
      # @return [Array<Sawyer::Resource>]
      def critical
        @client.get('criticalvulnerabilities')
      end

      # GET /api/search
      # Query vulnerabilities with flexible filters.
      #
      # @param params [Hash] Query parameters
      # @option params [String] :text Keywords (searches across description, EUVD ID, aliases, product, vendor)
      # @option params [Float] :fromScore Minimum CVSS score (0-10)
      # @option params [Float] :toScore Maximum CVSS score (0-10)
      # @option params [Integer] :fromEpss Minimum EPSS score (0-100)
      # @option params [Integer] :toEpss Maximum EPSS score (0-100)
      # @option params [String] :fromDate Minimum published date (YYYY-MM-DD)
      # @option params [String] :toDate Maximum published date (YYYY-MM-DD)
      # @option params [String] :fromUpdatedDate Minimum updated date (YYYY-MM-DD)
      # @option params [String] :toUpdatedDate Maximum updated date (YYYY-MM-DD)
      # @option params [String] :product Product name
      # @option params [String] :vendor Vendor name
      # @option params [String] :assigner Assigner name
      # @option params [Boolean] :exploited Filter by exploited status
      # @option params [Integer] :page Page number (starts at 0)
      # @option params [Integer] :size Page size (default 10, max 100)
      # @return [Sawyer::Resource] Search results with +.items+ (Array) and +.total+ (Integer)
      def search(params = {})
        @client.get('search', params)
      end
    end
  end
end
