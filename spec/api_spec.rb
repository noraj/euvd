# frozen_string_literal: true

RSpec.describe 'EUVD API modules' do
  let(:client) { EUVD::Client.new }
  let(:base) { EUVD::Client::BASE_URL }

  describe EUVD::API::Vulnerabilities do
    let(:api) { client.vulnerabilities }

    describe '#latest' do
      before do
        stub_request(:get, "#{base}/lastvulnerabilities")
          .to_return(status: 200, body: fixture('vulnerability_array.json'), headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns an Array' do
        expect(api.latest).to be_a(Array)
      end

      it 'returns vulnerability items' do
        expect(api.latest.first.id).to eq('EUVD-2026-41753')
      end
    end

    describe '#exploited' do
      before do
        stub_request(:get, "#{base}/exploitedvulnerabilities")
          .to_return(status: 200, body: fixture('vulnerability_array.json'), headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns an Array' do
        expect(api.exploited).to be_a(Array)
      end
    end

    describe '#critical' do
      before do
        stub_request(:get, "#{base}/criticalvulnerabilities")
          .to_return(status: 200, body: fixture('vulnerability_array.json'), headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns an Array' do
        expect(api.critical).to be_a(Array)
      end
    end

    describe '#search' do
      before do
        stub_request(:get, "#{base}/search")
          .with(query: { text: 'log4j', size: 10 })
          .to_return(status: 200, body: fixture('vulnerability.json'), headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns search results' do
        result = api.search(text: 'log4j', size: 10)
        expect(result.items).to be_a(Array)
        expect(result.total).to eq(1)
      end
    end
  end

  describe EUVD::API::Records do
    let(:api) { client.records }

    describe '#find' do
      before do
        stub_request(:get, "#{base}/enisaid")
          .with(query: { id: 'EUVD-2026-41753' })
          .to_return(status: 200, body: fixture('records.json'), headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns a Sawyer::Resource' do
        record = api.find('EUVD-2026-41753')
        expect(record).to be_a(Sawyer::Resource)
        expect(record.id).to eq('EUVD-2026-41753')
        expect(record.assigner).to eq('ENISA')
      end
    end

    describe '#advisory' do
      before do
        stub_request(:get, "#{base}/advisory")
          .with(query: { id: 'oxas-adv-2024-0002' })
          .to_return(status: 200, body: fixture('records.json'), headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns advisory data' do
        record = api.advisory('oxas-adv-2024-0002')
        expect(record.id).to eq('EUVD-2026-41753')
      end
    end
  end

  describe EUVD::API::Downloads do
    let(:api) { client.downloads }

    describe '#cve_euvd_mapping' do
      before do
        stub_request(:get, "#{base}/dump/cve-euvd-mapping")
          .to_return(status: 200, body: 'euvd_id,cve_id', headers: { 'Content-Type' => 'text/csv' })
      end

      it 'returns CSV data as a String' do
        result = api.cve_euvd_mapping
        expect(result).to be_a(String)
        expect(result).to eq('euvd_id,cve_id')
      end
    end

    describe '#kev_dump' do
      before do
        stub_request(:get, "#{base}/kev/dump")
          .to_return(status: 200, body: '[{"cveId":"CVE-2021-44228"}]', headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns KEV data' do
        result = api.kev_dump
        expect(result).to be_a(Array)
        expect(result.first.cveId).to eq('CVE-2021-44228')
      end
    end
  end

  describe EUVD::API::Meta do
    let(:api) { client.meta }

    describe '#assigners' do
      before do
        stub_request(:get, "#{base}/assigners/names")
          .to_return(status: 200, body: '["ENISA","NCSC-FI"]', headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns an array of assigner names' do
        expect(api.assigners).to eq(%w[ENISA NCSC-FI])
      end
    end

    describe '#banner' do
      before do
        stub_request(:get, "#{base}/banner")
          .to_return(status: 200, body: '{"enabled":true,"message":"test"}', headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns banner status' do
        expect(api.banner.enabled).to be true
        expect(api.banner.message).to eq('test')
      end
    end
  end

  describe EUVD::API::Observations do
    let(:api) { client.observations }

    describe '#honeypot_by_cve' do
      before do
        stub_request(:get, "#{base}/honeypotObservations")
          .with(query: { cveId: 'CVE-2021-44228' })
          .to_return(status: 200, body: '[]', headers: { 'Content-Type' => 'application/json' })
      end

      it 'queries honeypot observations for a CVE' do
        expect(api.honeypot_by_cve('CVE-2021-44228')).to eq([])
      end
    end

    describe '#honeypot_batch' do
      before do
        stub_request(:get, "#{base}/honeypotObservations/batch")
          .with(query: { ids: 'CVE-2021-44228,CVE-2021-45046' })
          .to_return(status: 200, body: '[]', headers: { 'Content-Type' => 'application/json' })
      end

      it 'accepts an array of IDs' do
        expect(api.honeypot_batch(%w[CVE-2021-44228 CVE-2021-45046])).to eq([])
      end
    end

    describe '#kev_by_cve' do
      before do
        stub_request(:get, "#{base}/kevEntries")
          .with(query: { cveId: 'CVE-2021-44228' })
          .to_return(status: 200, body: '[]', headers: { 'Content-Type' => 'application/json' })
      end

      it 'queries KEV entries for a CVE' do
        expect(api.kev_by_cve('CVE-2021-44228')).to eq([])
      end
    end

    describe '#kev_batch' do
      before do
        stub_request(:get, "#{base}/kevEntries/batch")
          .with(query: { ids: 'CVE-2021-44228' })
          .to_return(status: 200, body: '[]', headers: { 'Content-Type' => 'application/json' })
      end

      it 'accepts a single ID string' do
        expect(api.kev_batch('CVE-2021-44228')).to eq([])
      end
    end
  end
end
