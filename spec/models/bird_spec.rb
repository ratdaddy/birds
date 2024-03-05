require 'rails_helper'

RSpec.describe Bird, type: :model do
  describe('::find_birds_from_nodes_and_descendants') do
    let(:node_a) { Node.create! }
    let(:node_a_desc) { Node.create!(parent: node_a) }
    let(:node_b) { Node.create! }
    let!(:bird_a) { Bird.create!(node: node_a) }
    let!(:bird_a_desc) { Bird.create!(node: node_a_desc) }
    let!(:bird_b) { Bird.create!(node: node_b) }

    it 'returns all bird descendants of a single node' do
      result = Bird.find_birds_from_nodes_and_descendants(node_a.id)

      aggregate_failures do
        expect(result.length).to eq(2)
        expect(result).to contain_exactly(bird_a_desc, bird_a)
        expect(result).to include(bird_a)
        expect(result).to include(bird_a_desc)
      end
    end

    it 'returns all bird descendants of multiple nodes' do
      result = Bird.find_birds_from_nodes_and_descendants(node_a.id, node_b.id)

      aggregate_failures do
        expect(result.length).to eq(3)
        expect(result).to include(bird_a)
        expect(result).to include(bird_a_desc)
        expect(result).to include(bird_b)
      end
    end

    it 'does not return duplicates if descendant nodes are present' do
      result = Bird.find_birds_from_nodes_and_descendants(node_a.id, node_a_desc)

      aggregate_failures do
        expect(result.length).to eq(2)
        expect(result).to include(bird_a)
        expect(result).to include(bird_a_desc)
      end
    end
  end
end
