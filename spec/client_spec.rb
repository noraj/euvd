# frozen_string_literal: true

RSpec.describe EUVD::Client do
  subject(:client) { described_class.new }
  let(:base_url) { described_class::BASE_URL }

  describe '.new' do
    it 'creates a client' do
      expect(client).to be_a(described_class)
    end

    it 'defaults base_url to the real EUVD API' do
      expect(client.base_url).to eq(base_url)
    end

    it 'allows overriding base_url' do
      custom = described_class.new(base_url: 'http://localhost:3000/api')
      expect(custom.base_url).to eq('http://localhost:3000/api')
    end
  end

  describe 'API accessors' do
    it 'vulnerabilities' do
      expect(client.vulnerabilities).to be_a(EUVD::API::Vulnerabilities)
    end

    it 'records' do
      expect(client.records).to be_a(EUVD::API::Records)
    end

    it 'downloads' do
      expect(client.downloads).to be_a(EUVD::API::Downloads)
    end

    it 'meta' do
      expect(client.meta).to be_a(EUVD::API::Meta)
    end

    it 'observations' do
      expect(client.observations).to be_a(EUVD::API::Observations)
    end
  end

  describe '#get' do
    let(:stub_url) { "#{base_url}/test" }

    it 'returns parsed JSON data' do
      stub_request(:get, stub_url)
        .to_return(status: 200, body: '{"message":"ok"}', headers: { 'Content-Type' => 'application/json' })
      data = client.get('test')
      expect(data.message).to eq('ok')
    end

    it 'returns a Sawyer::Resource' do
      stub_request(:get, stub_url)
        .to_return(status: 200, body: '{"id":42}', headers: { 'Content-Type' => 'application/json' })
      data = client.get('test')
      expect(data).to be_a(Sawyer::Resource)
      expect(data.id).to eq(42)
    end

    it 'passes query parameters' do
      stub_request(:get, stub_url)
        .with(query: { foo: 'bar' })
        .to_return(status: 200, body: '{}', headers: { 'Content-Type' => 'application/json' })
      client.get('test', { foo: 'bar' })
      expect(WebMock).to have_requested(:get, stub_url).with(query: { foo: 'bar' })
    end

    context 'when the API returns HTML instead of JSON' do
      before do
        stub_request(:get, stub_url)
          .to_return(status: 200, body: '<html>Unavailable</html>', headers: { 'Content-Type' => 'text/html' })
      end

      it 'raises BadResponseError' do
        expect { client.get('test') }.to raise_error(EUVD::BadResponseError)
      end
    end

    context 'HTTP errors' do
      before do
        stub_request(:get, stub_url)
          .to_return(status: status_code, body: '{}', headers: { 'Content-Type' => 'application/json' })
      end

      context '404' do
        let(:status_code) { 404 }
        it 'raises NotFoundError' do
          expect { client.get('test') }.to raise_error(EUVD::NotFoundError)
        end
      end

      context '429' do
        let(:status_code) { 429 }
        it 'raises RateLimitError' do
          expect { client.get('test') }.to raise_error(EUVD::RateLimitError)
        end
      end

      context '500' do
        let(:status_code) { 500 }
        it 'raises ServerError' do
          expect { client.get('test') }.to raise_error(EUVD::ServerError)
        end
      end

      context '200 with JSON' do
        let(:status_code) { 200 }
        it 'does not raise' do
          expect { client.get('test') }.not_to raise_error
        end
      end
    end
  end
end
