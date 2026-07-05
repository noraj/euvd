# frozen_string_literal: true

RSpec.describe EUVD::API::CVE do
  subject(:api) { client.cve }
  let(:client) { EUVD::Client.new }
  let(:base_url) { EUVD::Client::BASE_URL }

  describe '#find' do
    before do
      stub_request(:get, "#{base_url}cve/CVE-2021-44228")
        .to_return(status: 200, body: fixture('cve_detail.json'), headers: { 'Content-Type' => 'application/json' })
    end

    it 'returns a Sawyer::Resource for a valid CVE ID' do
      result = api.find('CVE-2021-44228')
      expect(result).to be_a(Sawyer::Resource)
      expect(result.id).to eq('CVE-2021-44228')
      expect(result.severity).to eq('CRITICAL')
      expect(result.cvss_score).to eq(10.0)
    end

    it 'sends the request to the correct endpoint' do
      api.find('CVE-2021-44228')
      expect(WebMock).to have_requested(:get, "#{base_url}cve/CVE-2021-44228")
    end
  end

  describe '#search' do
    before do
      stub_request(:get, "#{base_url}cve")
        .with(query: { q: 'log4j' })
        .to_return(status: 200, body: fixture('cve_list.json'), headers: { 'Content-Type' => 'application/json' })

      stub_request(:get, "#{base_url}cve")
        .with(query: { q: 'log4j', page: 2 })
        .to_return(status: 200, body: fixture('cve_list.json'), headers: { 'Content-Type' => 'application/json' })
    end

    it 'accepts a string query' do
      results = api.search('log4j')
      expect(results).to be_a(Sawyer::Resource)
      expect(results.total).to eq(2)
    end

    it 'accepts a hash query' do
      results = api.search(q: 'log4j')
      expect(results.total).to eq(2)
    end

    it 'merges additional options' do
      api.search(q: 'log4j', page: 2)
      expect(WebMock).to have_requested(:get, "#{base_url}cve")
        .with(query: { q: 'log4j', page: 2 })
    end
  end

  describe '#list' do
    before do
      stub_request(:get, "#{base_url}cve")
        .with(query: { per_page: 10 })
        .to_return(status: 200, body: fixture('cve_list.json'), headers: { 'Content-Type' => 'application/json' })
    end

    it 'lists CVEs with pagination options' do
      results = api.list(per_page: 10)
      expect(results.total).to eq(2)
      expect(results.results.size).to eq(2)
    end
  end

  describe '#recent' do
    before do
      stub_request(:get, "#{base_url}cve/recent")
        .with(query: { limit: 5 })
        .to_return(status: 200, body: fixture('cve_list.json'), headers: { 'Content-Type' => 'application/json' })
    end

    it 'fetches recent CVEs' do
      results = api.recent(limit: 5)
      expect(results.total).to eq(2)
    end
  end
end
