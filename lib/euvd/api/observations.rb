# frozen_string_literal: true

module EUVD
  module API
    # Access to honeypot observation and KEV entry endpoints.
    class Observations
      def initialize(client)
        @client = client
      end

      # GET /api/honeypotObservations?cveId=X
      # Returns honeypot observations for a specific CVE.
      #
      # @param cve_id [String] CVE identifier (e.g. 'CVE-2021-44228')
      # @return [Array<Sawyer::Resource>]
      def honeypot_by_cve(cve_id)
        @client.get('honeypotObservations', cveId: cve_id)
      end

      # GET /api/honeypotObservations/batch?ids=X,Y
      # Returns honeypot observations for multiple CVEs.
      #
      # @param ids [Array<String>] CVE identifiers
      # @return [Array<Sawyer::Resource>]
      def honeypot_batch(ids)
        ids = ids.join(',') if ids.is_a?(Array)
        @client.get('honeypotObservations/batch', ids: ids)
      end

      # GET /api/kevEntries?cveId=X
      # Returns KEV entries for a specific CVE.
      #
      # @param cve_id [String] CVE identifier
      # @return [Array<Sawyer::Resource>]
      def kev_by_cve(cve_id)
        @client.get('kevEntries', cveId: cve_id)
      end

      # GET /api/kevEntries/batch?ids=X,Y
      # Returns KEV entries for multiple CVEs.
      #
      # @param ids [Array<String>] CVE identifiers
      # @return [Array<Sawyer::Resource>]
      def kev_batch(ids)
        ids = ids.join(',') if ids.is_a?(Array)
        @client.get('kevEntries/batch', ids: ids)
      end
    end
  end
end
