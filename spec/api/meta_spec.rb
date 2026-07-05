# frozen_string_literal: true

RSpec.describe EUVD::API::Meta do
  subject(:api) { client.meta }
  let(:client) { EUVD::Client.new }
  let(:base) { EUVD::Client::BASE_URL }

  describe '#assigners' do
    before do
      stub_request(:get, "#{base}/assigners/names")
        .to_return(status: 200, body: '["ENISA","NCSC-FI"]', headers: { 'Content-Type' => 'application/json' })
    end

    it 'returns the list of assigners' do
      expect(api.assigners).to eq(['ENISA', 'NCSC-FI'])
    end
  end

  describe '#banner' do
    before do
      stub_request(:get, "#{base}/banner")
        .to_return(status: 200, body: '{"enabled":false,"message":"."}', headers: { 'Content-Type' => 'application/json' })
    end

    it 'returns banner status as a Sawyer::Resource' do
      banner = api.banner
      expect(banner).to be_a(Sawyer::Resource)
      expect(banner.enabled).to be false
    end
  end
end
