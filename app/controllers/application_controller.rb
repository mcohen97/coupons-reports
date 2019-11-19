require './lib/json_web_token.rb'
require './lib/error/promotion_not_found_error.rb'
require './lib/error/not_authorized_error.rb'


class ApplicationController < ActionController::API
  rescue_from PromotionNotFoundError, with: :promotion_not_found
  rescue_from NotAuthorizedError, with: :not_authorized
  before_action :authenticate_request

  def not_found
    render json: { error_message: 'not_found' }, status: :not_found
  end

  def not_authorized(error)
    render json: { error_message: error.message }, status: :forbidden
  end

  def authenticate_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      set_organization_id(@decoded)
      set_permissions(@decoded)
    rescue JWT::DecodeError => e
      render json: { error_message: 'Invalid token' }, status: :unauthorized
    end
  end

  def promotion_not_found
    render json: { error_message: 'Cannot generate report, promotion does not exist' }, status: :not_found
  end

  def set_organization_id(payload)
    org_id = payload['organization_id']
    if org_id.nil?
      render json: { error_message: 'Invalid token' }, status: :unauthorized
    else
      @organization_id = org_id
    end
  end

  def set_permissions(payload)
    @permissions = payload['permissions'] || []
  end

end
