# frozen_string_literal: true

module EUVD
  module API
    class Search
      PATH = 'search'

      def initialize(client)
        @client = client
      end

      def all(query = {}, options = {})
        query = { q: query } if query.is_a?(String)
        @client.get(PATH, query: query.merge(options)).data
      end

      def cve(query = {}, options = {})
        query = { q: query } if query.is_a?(String)
        @client.get("#{PATH}/cve", query: query.merge(options)).data
      end

      def cpe(query = {}, options = {})
        query = { q: query } if query.is_a?(String)
        @client.get("#{PATH}/cpe", query: query.merge(options)).data
      end

      def cwe(query = {}, options = {})
        query = { q: query } if query.is_a?(String)
        @client.get("#{PATH}/cwe", query: query.merge(options)).data
      end

      def capec(query = {}, options = {})
        query = { q: query } if query.is_a?(String)
        @client.get("#{PATH}/capec", query: query.merge(options)).data
      end

      def advisory(query = {}, options = {})
        query = { q: query } if query.is_a?(String)
        @client.get("#{PATH}/advisory", query: query.merge(options)).data
      end
    end
  end
end
