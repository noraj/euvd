# frozen_string_literal: true

module EUVD
  module API
    class Vulnerabilities
      def initialize(client)
        @client = client
      end

      # GET /api/lastvulnerabilities
      # Returns the latest vulnerabilities (maximum 8 records).
      def latest
        @client.get('lastvulnerabilities')
      end

      # GET /api/exploitedvulnerabilities
      # Returns the latest exploited vulnerabilities (maximum 8 records).
      def exploited
        @client.get('exploitedvulnerabilities')
      end

      # GET /api/criticalvulnerabilities
      # Returns the latest critical vulnerabilities (maximum 8 records).
      def critical
        @client.get('criticalvulnerabilities')
      end

      # GET /api/search
      # Query vulnerabilities with flexible filters.
      #
      # Parameters:
      #   text: keywords (searches across description, EUVD ID, aliases, product name, vendor name)
      #   fromScore, toScore: CVSS score range (0-10)
      #   fromEpss, toEpss: EPSS score range (0-100)
      #   fromDate, toDate: published date range (YYYY-MM-DD)
      #   fromUpdatedDate, toUpdatedDate: updated date range (YYYY-MM-DD)
      #   product: filter by product name
      #   vendor: filter by vendor name
      #   assigner: filter by assigner
      #   exploited: true/false
      #   page: page number (starts at 0)
      #   size: page size (default 10, max 100)
      def search(params = {})
        @client.get('search', params)
      end
    end
  end
end
