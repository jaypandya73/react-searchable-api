class Api::BaseApiController < ApplicationController
  
  respond_to :json

  before_filter :has_valid_authorization_header?

  def authorization_header
    request.headers['Authorization']
  end

  def has_valid_authorization_header?
    return false unless authorization_header
    authorization_header.include?("Bearer")
  end

  def authenticate_user_from_token
    if !payload || !JsonWebToken.new.valid_payload(payload)
      return invalid_authentication
    end
    load_current_user
    invalid_authentication unless @current_user
  end

  def invalid_authentication
    render json: {error: 'Invalid Request'}, status: :unauthorized
  end

  private
  # Deconstructs the Authorization header and decodes the JWT token.
  def payload
    begin
      auth_header = request.headers['Authorization']
      token = auth_header.split(' ').last
      JsonWebToken.new.decode(token)
    rescue
      nil
    end
  end

  def load_current_user
    @current_user = User.find_by(email: payload['user_email'])
  end

end
