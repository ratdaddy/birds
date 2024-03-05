class BirdsController < ApplicationController
  class BirdsFromNodesParamsSchema < ::Dry::Schema::Params
    define do
      required(:node_ids).filled(array[:integer])
    end
  end

  def from_nodes
    bird_params =  validate_params!
    birds = Bird.find_birds_from_nodes_and_descendants(*bird_params[:node_ids])
    render json: birds.map { |bird| bird.id }
  end

  private
    def validate_params!
      result = BirdsFromNodesParamsSchema.new.call(node_ids: node_id_params.fetch(:node_ids, '').split(','))

      if result.success?
        result.to_h
      else
        raise ActionController::BadRequest, 'Invalid http params'
      end
    end

    def node_id_params
      params.permit(:node_ids)
    end
end
