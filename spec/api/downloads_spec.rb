# frozen_string_literal: true

RSpec.describe EUVD::API::Downloads do
  subject(:api) { client.downloads }
  let(:client) { EUVD::Client.new }
  let(:base) { EUVD::Client::BASE_URL }

  describe '#cve_euvd_mapping' do
    before do
      stub_request(:get, "#{base}/dump/cve-euvd-mapping")
        .to_return(status: 200, body: 'euvd_id,cve_id
EUVD-2024-00001,CVE-2024-0001', headers: { 'Content-Type' => 'text/csv' })
    end

    it 'hits the correct endpoint' do
      api.cve_euvd_mapping
      expect(WebMock).to have_requested(:get, "#{base}/dump/cve-euvd-mapping")
    end
  end

  describe '#kev_dump' do
    before do
      stub_request(:get, "#{base}/kev/dump")
        .to_return(status: 200, body: '[{"cveId":"CVE-2021-44228"}]', headers: { 'Content-Type' => 'application/json' })
    end

    it 'hits the correct endpoint' do
      api.kev_dump
      expect(WebMock).to have_requested(:get, "#{base}/kev/dump")
    end
  end
end
