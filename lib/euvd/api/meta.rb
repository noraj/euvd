# frozen_string_literal: true

module EUVD
  module API
    class Meta
      def initialize(client)
        @client = client
      end

      # GET /api/assigners/names
      # Returns the list of assigner names.
      def assigners
        @client.get('assigners/names')
      end

      # GET /api/banner
      # Returns the banner status (enabled/message).
      def banner
        @client.get('banner')
      end
    end
  end
end
