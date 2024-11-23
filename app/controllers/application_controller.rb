class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_request

  private

  def authenticate_request
    return if request.path.start_with?('/login', '/register', '/assets')

    token = extract_token

    if token.present? && token_valid?(token)
      @current_user = fetch_user_from_token(token)
    else
      respond_to do |format|
        format.html { redirect_to login_path, alert: 'You must log in to access this page.' }
        format.json { render json: { error: 'Unauthorized' }, status: :unauthorized }
      end
    end
  end

  def extract_token
    request.headers['Authorization']&.split(' ')&.last || session[:jwt]
  end

  def token_valid?(token)
    response = RestClient.get(
      "http://auth_service:4000/auth/validate",
      { Authorization: "Bearer #{token}" }
    )
    JSON.parse(response.body)['valid']
  rescue RestClient::Unauthorized, RestClient::Forbidden
    false
  rescue RestClient::ExceptionWithResponse => e
    Rails.logger.error "Error validating token via auth_service: #{e.message}"
    false
  end

  def fetch_user_from_token(token)
    response = RestClient.get(
      "http://auth_service:4000/auth/validate",
      { Authorization: "Bearer #{token}" }
    )
    JSON.parse(response.body)['user']
  rescue RestClient::ExceptionWithResponse => e
    Rails.logger.error "Error fetching user via auth_service: #{e.message}"
    nil
  rescue StandardError => e
    Rails.logger.error "Unexpected error fetching user: #{e.message}"
    nil
  end
end
