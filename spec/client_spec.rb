# frozen_string_literal: true

RSpec.describe EUVD::Client do
  subject(:client) { described_class.new }

  describe '.new' do
    it 'creates a new client' do
      expect(client).to be_a(described_class)
    end

    it 'defaults to the production base URL' do
      expect(client.send(:instance_variable_get, :@base_url)).to eq(described_class::BASE_URL)
    end

    it 'defaults per_page to 20' do
      expect(client.per_page).to eq(20)
    end

    it 'does not require any authentication' do
      expect(client).not_to respond_to(:api_key)
    end
  end

  describe '#inspect' do
    it 'shows the base URL' do
      expect(client.inspect).to include(client.send(:instance_variable_get, :@base_url))
    end
  end

  describe 'API accessors' do
    it 'returns a CVE API instance' do
      expect(client.cve).to be_a(EUVD::API::CVE)
    end

    it 'returns a CPE API instance' do
      expect(client.cpe).to be_a(EUVD::API::CPE)
    end

    it 'returns a CWE API instance' do
      expect(client.cwe).to be_a(EUVD::API::CWE)
    end

    it 'returns a CAPEC API instance' do
      expect(client.capec).to be_a(EUVD::API::CAPEC)
    end

    it 'returns an Advisory API instance' do
      expect(client.advisory).to be_a(EUVD::API::Advisory)
    end

    it 'returns a Statistics API instance' do
      expect(client.statistics).to be_a(EUVD::API::Statistics)
    end

    it 'returns a Search API instance' do
      expect(client.search).to be_a(EUVD::API::Search)
    end
  end

  describe '#get' do
    let(:stub_url) { "#{described_class::BASE_URL}test" }

    before do
      stub_request(:get, stub_url)
        .to_return(status: 200, body: '{"message":"ok"}', headers: { 'Content-Type' => 'application/json' })
    end

    it 'returns a Sawyer::Response' do
      response = client.get('test')
      expect(response).to be_a(Sawyer::Response)
    end

    it 'parses JSON response data' do
      response = client.get('test')
      expect(response.data.message).to eq('ok')
    end

    it 'passes query parameters' do
      stub_request(:get, stub_url)
        .with(query: { foo: 'bar' })
        .to_return(status: 200, body: '{}', headers: { 'Content-Type' => 'application/json' })
      client.get('test', query: { foo: 'bar' })
      expect(WebMock).to have_requested(:get, stub_url).with(query: { foo: 'bar' })
    end

    it 'sends a GET request' do
      client.get('test')
      expect(WebMock).to have_requested(:get, stub_url)
    end
  end

  describe 'error handling' do
    let(:stub_url) { "#{described_class::BASE_URL}test" }

    before do
      stub_request(:get, stub_url).to_return(status: status_code, body: '{}', headers: { 'Content-Type' => 'application/json' })
    end

    context 'when 404 is returned' do
      let(:status_code) { 404 }

      it 'raises NotFoundError' do
        expect { client.get('test') }.to raise_error(EUVD::NotFoundError)
      end
    end

    context 'when 429 is returned' do
      let(:status_code) { 429 }

      it 'raises RateLimitError' do
        expect { client.get('test') }.to raise_error(EUVD::RateLimitError)
      end
    end

    context 'when 500 is returned' do
      let(:status_code) { 500 }

      it 'raises ServerError' do
        expect { client.get('test') }.to raise_error(EUVD::ServerError)
      end
    end

    context 'when 200 is returned' do
      let(:status_code) { 200 }

      it 'does not raise an error' do
        expect { client.get('test') }.not_to raise_error
      end
    end
  end
end
