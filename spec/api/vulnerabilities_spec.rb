# frozen_string_literal: true

RSpec.describe EUVD::API::Vulnerabilities do
  subject(:api) { client.vulnerabilities }
  let(:client) { EUVD::Client.new }
  let(:base) { EUVD::Client::BASE_URL }

  VULNS_ARRAY = [
    {
      'id' => 'EUVD-2026-41755',
      'enisaUuid' => '9a890ffc-a717-3d27-82bf-39fc6084b7e9',
      'description' => 'A vulnerability was identified in mjperpinosa stumasy...',
      'datePublished' => 'Jul 5, 2026, 12:45:07 PM',
      'dateUpdated' => 'Jul 5, 2026, 12:45:07 PM',
      'baseScore' => 6.9,
      'baseScoreVersion' => '4.0',
      'baseScoreVector' => 'CVSS:4.0/AV:N/AC:L/AT:N/PR:N/UI:N/VC:L/VI:L/VA:L/SC:N/SI:N/SA:N/E:P',
      'references' => 'https://vuldb.com/vuln/376338',
      'assigner' => 'VulDB',
      'aliases' => 'CVE-2026-14749',
      'epss' => 0.0
    }
  ].to_json

  SEARCH_RESULT = {
    'items' => [
      {
        'id' => 'EUVD-2026-41755',
        'description' => 'A vulnerability was identified in mjperpinosa stumasy...',
        'baseScore' => 6.9,
        'assigner' => 'VulDB'
      }
    ],
    'total' => 16278
  }.to_json

  describe '#latest' do
    before do
      stub_request(:get, "#{base}/lastvulnerabilities")
        .to_return(status: 200, body: VULNS_ARRAY, headers: { 'Content-Type' => 'application/json' })
    end

    it 'returns Array of Sawyer::Resource' do
      results = api.latest
      expect(results).to be_a(Array)
      expect(results.first).to be_a(Sawyer::Resource)
    end

    it 'exposes attributes as methods on the resource' do
      results = api.latest
      expect(results.first.id).to eq('EUVD-2026-41755')
      expect(results.first.baseScore).to eq(6.9)
    end

    it 'hits the correct endpoint' do
      api.latest
      expect(WebMock).to have_requested(:get, "#{base}/lastvulnerabilities")
    end
  end

  describe '#exploited' do
    before do
      stub_request(:get, "#{base}/exploitedvulnerabilities")
        .to_return(status: 200, body: '[]', headers: { 'Content-Type' => 'application/json' })
    end
    it 'hits /exploitedvulnerabilities' do
      api.exploited
      expect(WebMock).to have_requested(:get, "#{base}/exploitedvulnerabilities")
    end
  end

  describe '#critical' do
    before do
      stub_request(:get, "#{base}/criticalvulnerabilities")
        .to_return(status: 200, body: '[]', headers: { 'Content-Type' => 'application/json' })
    end
    it 'hits /criticalvulnerabilities' do
      api.critical
      expect(WebMock).to have_requested(:get, "#{base}/criticalvulnerabilities")
    end
  end

  describe '#search' do
    before do
      stub_request(:get, "#{base}/search")
        .with(query: hash_including(text: 'windows'))
        .to_return(status: 200, body: SEARCH_RESULT, headers: { 'Content-Type' => 'application/json' })
    end

    it 'returns a Sawyer::Resource with items and total' do
      results = api.search(text: 'windows', size: 10)
      expect(results).to be_a(Sawyer::Resource)
      expect(results.items).to be_a(Array)
      expect(results.items.first.id).to eq('EUVD-2026-41755')
      expect(results.total).to eq(16278)
    end
  end
end
