require 'rails_helper'

RSpec.describe "Ancestors", type: :request do
  let(:headers) {{ "ACCEPT" => "application/json" }}

  describe "GET /common_ancestor" do
    let(:root) { Node.create! }
    let(:lowest_common_ancestor) { Node.create!(parent: root) }
    let(:child_a) { Node.create!(parent: lowest_common_ancestor) }
    let(:child_b) { Node.create!(parent: lowest_common_ancestor) }

    it 'returns http success' do
      get '/common_ancestor', params: { a: 1, b: 1 }

      expect(response).to have_http_status(:success)
    end

    it 'returns the root and LCA' do
      get '/common_ancestor', params: { a: child_a.id, b: child_b.id }, headers: headers

      json = JSON.parse(response.body).symbolize_keys
      expect(json).to eq(root_id: root.id, lowest_common_ancestor_id: lowest_common_ancestor.id, depth: 2)
    end

    it 'return nulls if node not in database' do
      get '/common_ancestor', params: { a: child_a.id, b: 9_223_372_036_854_775_807 }, headers: headers

      json = JSON.parse(response.body).symbolize_keys
      expect(json).to eq(root_id: nil, lowest_common_ancestor_id: nil, depth: nil)
    end

    it 'returns http bad request if missing params' do
      get '/common_ancestor', params: {}, headers: headers

      expect(response).to have_http_status(:bad_request)
    end

    it 'returns http bad request if params missing values' do
      get '/common_ancestor', params: { a: nil, b: nil }, headers: headers

      expect(response).to have_http_status(:bad_request)
    end

    it 'returns http bad request if invalid param names' do
      get '/common_ancestor', params: { a: 1, b: 2, c: 3 }, headers: headers

      expect(response).to have_http_status(:bad_request)
    end

    it 'returns http bad request if invalid param types' do
      get '/common_ancestor', params: { a: 'abc', b: 2 }, headers: headers

      expect(response).to have_http_status(:bad_request)
    end
  end
end
