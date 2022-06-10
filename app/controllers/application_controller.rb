class ApplicationController < ActionController::Base
  before_action :set_default_response_format

  def set_default_response_format
    request.format = :json unless params[:format]
  end
end
