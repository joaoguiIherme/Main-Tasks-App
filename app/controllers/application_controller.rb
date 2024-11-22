class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # before_action :authenticate_request

  private

  def authenticate_request
    token = request.headers['Authorization']&.split(' ')&.last
    if token.present?
      response = HTTP.headers(accept: 'application/json').get("http://auth_service:4000/auth/validate", params: { token: token })
      if response.status.success?
        @current_user = JSON.parse(response.body.to_s)['user']
      else
        redirect_to login_path, alert: 'Você precisa fazer login para acessar esta página.'
      end
    else
      redirect_to login_path, alert: 'Você precisa fazer login para acessar esta página.'
    end
  end

  def render_unauthorized
    respond_to do |format|
      format.html { redirect_to login_path, alert: "Você precisa fazer login para acessar esta página." }
      format.json { render json: { error: "Unauthorized" }, status: :unauthorized }
    end
  end
end
