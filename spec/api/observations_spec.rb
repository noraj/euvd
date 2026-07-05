# frozen_string_literal: true

RSpec.describe EUVD::API::Observations do
  subject(:api) { client.observations }
  let(:client) { EUVD::Client.new }
  let(:base) { EUVD::Client::BASE_URL }

  describe '#honeypot_by_cve' do
    before do
      stub_request(:get, "#{base}/honeypotObservations")
        .with(query: { cveId: 'CVE-2021-44228' })
        .to_return(status: 200, body: '[]', headers: { 'Content-Type' => 'application/json' })
    end

    it 'hits /honeypotObservations with cveId query param' do
      api.honeypot_by_cve('CVE-2021-44228')
      expect(WebMock).to have_requested(:get, "#{base}/honeypotObservations")
        .with(query: { cveId: 'CVE-2021-44228' })
    end
  end

  describe '#honeypot_batch' do
    before do
      stub_request(:get, "#{base}/honeypotObservations/batch")
        .with(query: { ids: 'CVE-2021-44228,CVE-2022-22965' })
        .to_return(status: 200, body: '[]', headers: { 'Content-Type' => 'application/json' })
    end

    it 'joins array ids with comma' do
      api.honeypot_batch(['CVE-2021-44228', 'CVE-2022-22965'])
      expect(WebMock).to have_requested(:get, "#{base}/honeypotObservations/batch")
        .with(query: { ids: 'CVE-2021-44228,CVE-2022-22965' })
    end
  end

  describe '#kev_by_cve' do
    before do
      stub_request(:get, "#{base}/kevEntries")
        .with(query: { cveId: 'CVE-2021-44228' })
        .to_return(status: 200, body: '[]', headers: { 'Content-Type' => 'application/json' })
    end

    it 'hits /kevEntries with cveId' do
      api.kev_by_cve('CVE-2021-44228')
      expect(WebMock).to have_requested(:get, "#{base}/kevEntries")
        .with(query: { cveId: 'CVE-2021-44228' })
    end
  end

  describe '#kev_batch' do
    before do
      stub_request(:get, "#{base}/kevEntries/batch")
        .with(query: { ids: 'CVE-2021-44228' })
        .to_return(status: 200, body: '[]', headers: { 'Content-Type' => 'application/json' })
    end

    it 'joins array ids with comma' do
      api.kev_batch(['CVE-2021-44228'])
      expect(WebMock).to have_requested(:get, "#{base}/kevEntries/batch")
        .with(query: { ids: 'CVE-2021-44228' })
    end
  end
end
