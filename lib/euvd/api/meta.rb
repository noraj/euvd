# frozen_string_literal: true

module EUVD
  module API
    # Access to meta/utility endpoints (banner, assigners list).
    class Meta
      def initialize(client)
        @client = client
      end

      # GET /api/assigners/names
      # Returns the list of assigner names.
      #
      # @return [Array<String>]
      def assigners
        @client.get('assigners/names')
      end

      # GET /api/banner
      # Returns the banner status (enabled/message).
      #
      # @return [Sawyer::Resource]
      def banner
        @client.get('banner')
      end
    end
  end
end
