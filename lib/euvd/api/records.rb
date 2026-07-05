# frozen_string_literal: true

module EUVD
  module API
    class Records
      def initialize(client)
        @client = client
      end

      # GET /api/enisaid?id=EUVD-XXXX-XXXXX
      # Returns a single EUVD record by its EUVD ID.
      def enisaid(euvd_id)
        @client.get('enisaid', id: euvd_id)
      end

      alias find enisaid

      # GET /api/advisory?id=XXXXX
      # Returns a single advisory by its ID.
      def advisory(advisory_id)
        @client.get('advisory', id: advisory_id)
      end
    end
  end
end
