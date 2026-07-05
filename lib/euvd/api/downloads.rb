# frozen_string_literal: true

module EUVD
  module API
    class Downloads
      def initialize(client)
        @client = client
      end

      # GET /api/dump/cve-euvd-mapping
      # Downloads the CVE-to-EUVD ID mapping as CSV.
      def cve_euvd_mapping
        @client.get('dump/cve-euvd-mapping')
      end

      # GET /api/kev/dump
      # Downloads the full KEV dump as JSON.
      def kev_dump
        @client.get('kev/dump')
      end
    end
  end
end
