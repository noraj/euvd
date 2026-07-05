# frozen_string_literal: true

module EUVD
  module API
    class Observations
      def initialize(client)
        @client = client
      end

      # GET /api/honeypotObservations?cveId=X
      def honeypot_by_cve(cve_id)
        @client.get('honeypotObservations', cveId: cve_id)
      end

      # GET /api/honeypotObservations/batch?ids=X,Y
      def honeypot_batch(ids)
        ids = ids.join(',') if ids.is_a?(Array)
        @client.get('honeypotObservations/batch', ids: ids)
      end

      # GET /api/kevEntries?cveId=X
      def kev_by_cve(cve_id)
        @client.get('kevEntries', cveId: cve_id)
      end

      # GET /api/kevEntries/batch?ids=X,Y
      def kev_batch(ids)
        ids = ids.join(',') if ids.is_a?(Array)
        @client.get('kevEntries/batch', ids: ids)
      end
    end
  end
end
