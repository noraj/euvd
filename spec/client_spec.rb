# frozen_string_literal: true

RSpec.describe EUVD::Client do
  subject(:client) { described_class.new }
  let(:base) { described_class::BASE_URL }

  describe '.new' do
    it 'creates a client pointing at the real API base by default' do
      expect(client.send(:instance_variable_get, :@base_url)).to eq(base)
      expect(base).to eq('https://euvdservices.enisa.europa.eu/api')
    end
    it 'accepts a custom base_url' do
      custom = described_class.new(base_url: 'http://localhost:3000/api')
      expect(custom.send(:instance_variable_get, :@base_url)).to eq('http://localhost:3000/api')
    end
  end

  describe '#inspect' do
    it 'shows the base URL' do
      expect(client.inspect).to include(base)
    end
  end

  describe 'API accessors' do
    it 'returns a Vulnerabilities module' do
      expect(client.vulnerabilities).to be_a(EUVD::API::Vulnerabilities)
    end
    it 'returns a Records module' do
      expect(client.records).to be_a(EUVD::API::Records)
    end
    it 'returns a Downloads module' do
      expect(client.downloads).to be_a(EUVD::API::Downloads)
    end
    it 'returns a Meta module' do
      expect(client.meta).to be_a(EUVD::API::Meta)
    end
    it 'returns an Observations module' do
      expect(client.observations).to be_a(EUVD::API::Observations)
    end
  end

  describe '#get' do
    let(:stub_url) { "#{base}/test" }

    it 'returns Sawyer::Resource for JSON objects' do
      stub_request(:get, stub_url)
        .to_return(status: 200, body: '{"value":42}', headers: { 'Content-Type' => 'application/json' })
      data = client.get('test')
      expect(data).to be_a(Sawyer::Resource)
      expect(data.value).to eq(42)
    end

    it 'returns Array of Sawyer::Resource for JSON arrays' do
      stub_request(:get, stub_url)
        .to_return(status: 200, body: '[{"id":1}]', headers: { 'Content-Type' => 'application/json' })
      data = client.get('test')
      expect(data).to be_a(Array)
      expect(data.first).to be_a(Sawyer::Resource)
      expect(data.first.id).to eq(1)
    end

    it 'passes query parameters' do
      stub_request(:get, stub_url)
        .with(query: { foo: 'bar' })
        .to_return(status: 200, body: '{}', headers: { 'Content-Type' => 'application/json' })
      client.get('test', foo: 'bar')
      expect(WebMock).to have_requested(:get, stub_url).with(query: { foo: 'bar' })
    end

    it 'raises BadResponseError for HTML responses' do
      stub_request(:get, stub_url)
        .to_return(status: 200, body: '<!doctype html>', headers: { 'Content-Type' => 'text/html' })
      expect { client.get('test') }.to raise_error(EUVD::BadResponseError)
    end

    it 'raises NotFoundError on 404' do
      stub_request(:get, stub_url).to_return(status: 404, body: '{}', headers: { 'Content-Type' => 'application/json' })
      expect { client.get('test') }.to raise_error(EUVD::NotFoundError)
    end

    it 'raises RateLimitError on 429' do
      stub_request(:get, stub_url).to_return(status: 429, body: '{}', headers: { 'Content-Type' => 'application/json' })
      expect { client.get('test') }.to raise_error(EUVD::RateLimitError)
    end

    it 'raises ServerError on 500' do
      stub_request(:get, stub_url).to_return(status: 500, body: '{}', headers: { 'Content-Type' => 'application/json' })
      expect { client.get('test') }.to raise_error(EUVD::ServerError)
    end

    it 'raises ServerError before BadResponseError when server error has HTML body' do
      stub_request(:get, stub_url)
        .to_return(status: 503, body: '<html>err</html>', headers: { 'Content-Type' => 'text/html' })
      expect { client.get('test') }.to raise_error(EUVD::ServerError)
    end
  end
end
