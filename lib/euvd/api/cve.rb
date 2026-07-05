# frozen_string_literal: true

module EUVD
  module API
    class CVE
      PATH = 'cve'

      def initialize(client)
        @client = client
      end

      def find(id, options = {})
        @client.get("#{PATH}/#{id}", options).data
      end

      def search(query = {}, options = {})
        query = { q: query } if query.is_a?(String)
        @client.get(PATH, query: query.merge(options)).data
      end

      def list(options = {})
        @client.get(PATH, query: options).data
      end

      def recent(options = {})
        @client.get("#{PATH}/recent", query: options).data
      end
    end
  end
end
