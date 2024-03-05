require 'rails_helper'

RSpec.describe "Birds", type: :request do
  let(:headers) {{ "ACCEPT" => "application/json" }}

  describe "GET /from_nodes" do
    let(:node_a) { Node.create! }
    let(:node_a_desc) { Node.create!(parent: node_a) }
    let(:node_b) { Node.create! }
    let!(:bird_a) { Bird.create!(node: node_a) }
    let!(:bird_a_desc) { Bird.create!(node: node_a_desc) }
    let!(:bird_b) { Bird.create!(node: node_b) }

    it "returns http success" do
      get "/birds", params: { node_ids: [1, 2].join(',') }, headers: headers

      expect(response).to have_http_status(:success)
    end

    it 'returns all bird descendants of a single node' do
      get "/birds", params: { node_ids: node_a.id }, headers: headers

      json = JSON.parse(response.body)
      expect(json).to contain_exactly(bird_a.id, bird_a_desc.id)
    end

    it 'returns all bird descendants of multiple nodes' do
      get "/birds", params: { node_ids: [node_a.id, node_b.id].join(',') }, headers: headers

      json = JSON.parse(response.body)
      expect(json).to contain_exactly(bird_a.id, bird_a_desc.id, bird_b.id)
    end

    it 'returns empty array if node not in database' do
      get "/birds", params: { node_ids: 9_223_372_036_854_775_807 }, headers: headers

      json = JSON.parse(response.body)
      expect(json).to eq([])
    end

    it 'returns http bad request if missing params' do
      get "/birds", params: {}, headers: headers

      expect(response).to have_http_status(:bad_request)
    end

    it 'returns http bad request if param missing values' do
      get "/birds", params: nil, headers: headers

      expect(response).to have_http_status(:bad_request)
    end

    it 'returns http bad request if invalid param names' do
      get "/birds", params: { node_ids: 1, invalid_param: 2 }, headers: headers

      expect(response).to have_http_status(:bad_request)
    end

    it 'returns http bad request if invalid param type' do
      get "/birds", params: { node_ids: 'abc' }, headers: headers

      expect(response).to have_http_status(:bad_request)
    end
  end
end
