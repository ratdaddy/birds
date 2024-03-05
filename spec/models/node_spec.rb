require 'rails_helper'

RSpec.describe Node, type: :model do
  describe '::find_root_and_lca' do
    let(:root) { Node.create! }
    let(:lowest_common_ancestor) { Node.create!(parent: root) }
    let(:child_a) { Node.create!(parent: lowest_common_ancestor) }
    let(:child_b) { Node.create!(parent: lowest_common_ancestor) }

    it 'returns the root (first element) and lowest common ancestor (LCA) (second element) given two children nodes' do
      result = Node.find_root_and_lca(child_a.id, child_b.id)

      aggregate_failures do
        expect(result.length).to eq(2)
        expect(result.first).to eq(root)
        expect(result.last).to eq(lowest_common_ancestor)
        expect(result.last.depth).to eq(2)
      end
    end

    it 'returns the root twice when it is also the LCA' do
      result = Node.find_root_and_lca(root.id, child_a.id)

      aggregate_failures do
        expect(result.length).to eq(2)
        expect(result.first).to eq(root)
        expect(result.last).to eq(root)
        expect(result.last.depth).to eq(1)
      end
    end

    it 'returns an empty array for ids that are not in the database' do
      result = Node.find_root_and_lca(root.id, 9_223_372_036_854_775_807)

      expect(result.length).to eq(0)
    end

    it 'returns the node itself as LCA if a == b' do
      result = Node.find_root_and_lca(child_a.id, child_a.id)

      aggregate_failures do
        expect(result.length).to eq(2)
        expect(result.first).to eq(root)
        expect(result.last).to eq(child_a)
        expect(result.last.depth).to eq(3)
      end
    end
  end
end
