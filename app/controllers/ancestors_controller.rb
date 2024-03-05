class AncestorsController < ApplicationController
  class CommonAncestorParamsSchema < ::Dry::Schema::Params
    define do
      required(:a).filled(:integer)
      required(:b).filled(:integer)
    end
  end

  def common
    ancestor_params = validate_params!
    nodes = Node.find_root_and_lca(ancestor_params[:a], ancestor_params[:b])
    render json: { root_id: nodes.first&.id, lowest_common_ancestor_id: nodes.last&.id, depth: nodes.last&.depth }
  end

  private
    def validate_params!
      result = CommonAncestorParamsSchema.new.call(common_ancestor_params.to_h)

      if result.success?
        result.to_h
      else
        raise ActionController::BadRequest, 'Invalid http params'
      end
    end

    def common_ancestor_params
      params.permit(:a, :b)
    end
end
