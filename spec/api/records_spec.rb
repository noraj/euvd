# frozen_string_literal: true

RSpec.describe EUVD::API::Records do
  subject(:api) { client.records }
  let(:client) { EUVD::Client.new }
  let(:base) { EUVD::Client::BASE_URL }

  RECORD_DETAIL = {
    'id' => 'EUVD-2026-41753',
    'enisaUuid' => '1e8ffebd-446c-3359-81cd-d67d8e23357d',
    'description' => 'An unauthenticated improper input validation vulnerability in the POST /fetch_cve_data endpoint in cve-search.',
    'datePublished' => 'Jul 2, 2026, 10:04:33 PM',
    'dateUpdated' => 'Jul 4, 2026, 1:27:11 AM',
    'baseScore' => 6.9,
    'baseScoreVersion' => '4.0',
    'baseScoreVector' => 'CVSS:4.0/AV:N/AC:L/AT:N/PR:N/UI:N/VC:L/VI:L/VA:L/SC:N/SI:N/SA:N/E:P',
    'references' => 'https://nvd.nist.gov/vuln/detail/CVE-2025-11111',
    'assigner' => 'VulDB',
    'aliases' => "CVE-2025-11111\nCVE-2025-22222"
  }.to_json

  ADVISORY_DETAIL = {
    'id' => 'oxas-adv-2024-0002',
    'description' => 'OX App Suite Security Advisory OXAS-ADV-2024-0002',
    'datePublished' => 'Mar 6, 2024, 12:00:00 AM',
    'dateUpdated' => 'May 6, 2024, 12:00:00 AM',
    'baseScore' => 0.0,
    'references' => 'https://documentation.open-xchange.com/appsuite/security/advisories/csaf/2024/oxas-adv-2024-0002.json'
  }.to_json

  describe '#enisaid (find)' do
    before do
      stub_request(:get, "#{base}/enisaid")
        .with(query: { id: 'EUVD-2026-41753' })
        .to_return(status: 200, body: RECORD_DETAIL, headers: { 'Content-Type' => 'application/json' })
    end

    it 'returns a Sawyer::Resource for a valid EUVD ID' do
      rec = api.enisaid('EUVD-2026-41753')
      expect(rec).to be_a(Sawyer::Resource)
      expect(rec.id).to eq('EUVD-2026-41753')
      expect(rec.baseScore).to eq(6.9)
    end

    it 'hits /enisaid with the id query param' do
      api.enisaid('EUVD-2026-41753')
      expect(WebMock).to have_requested(:get, "#{base}/enisaid")
        .with(query: { id: 'EUVD-2026-41753' })
    end
  end

  describe '#advisory' do
    before do
      stub_request(:get, "#{base}/advisory")
        .with(query: { id: 'oxas-adv-2024-0002' })
        .to_return(status: 200, body: ADVISORY_DETAIL, headers: { 'Content-Type' => 'application/json' })
    end

    it 'returns a Sawyer::Resource' do
      adv = api.advisory('oxas-adv-2024-0002')
      expect(adv).to be_a(Sawyer::Resource)
      expect(adv.id).to eq('oxas-adv-2024-0002')
    end
  end
end
