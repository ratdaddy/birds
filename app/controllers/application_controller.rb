class ApplicationController < ActionController::API
  rescue_from ActionController::UnpermittedParameters do
    render :nothing => true, :status => :bad_request
  end
end
