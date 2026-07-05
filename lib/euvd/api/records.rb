# frozen_string_literal: true

module EUVD
  module API
    # Access to specific resource endpoints: EUVD record by ID and advisory by ID.
    class Records
      def initialize(client)
        @client = client
      end

      # GET /api/enisaid?id=EUVD-XXXX-XXXXX
      # Returns a single EUVD record by its EUVD ID.
      #
      # @param euvd_id [String] EUVD identifier (e.g. 'EUVD-2024-45012')
      # @return [Sawyer::Resource]
      def enisaid(euvd_id)
        @client.get('enisaid', id: euvd_id)
      end

      # Alias for #enisaid.
      alias find enisaid

      # GET /api/advisory?id=XXXXX
      # Returns a single advisory by its ID.
      #
      # @param advisory_id [String] Advisory identifier (e.g. 'oxas-adv-2024-0002')
      # @return [Sawyer::Resource]
      def advisory(advisory_id)
        @client.get('advisory', id: advisory_id)
      end
    end
  end
end
