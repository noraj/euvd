# frozen_string_literal: true

module EUVD
  module API
    class Statistics
      PATH = 'statistics'

      def initialize(client)
        @client = client
      end

      def summary(options = {})
        @client.get(PATH, query: options).data
      end

      def cve_by_severity(options = {})
        @client.get("#{PATH}/cve-by-severity", query: options).data
      end

      def cve_by_year(options = {})
        @client.get("#{PATH}/cve-by-year", query: options).data
      end

      def top_vendors(options = {})
        @client.get("#{PATH}/top-vendors", query: options).data
      end

      def top_products(options = {})
        @client.get("#{PATH}/top-products", query: options).data
      end

      def cwe_by_occurrence(options = {})
        @client.get("#{PATH}/cwe-by-occurrence", query: options).data
      end
    end
  end
end
