# app/middleware/jwt_authentication.rb
class JwtAuthentication
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    Rails.logger.info "Verificando autenticação para a rota: #{request.path}"
  
    if protected_route?(request.path)
      token = request.get_header("HTTP_AUTHORIZATION")&.split("Bearer ")&.last
      unless token && valid_token?(token)
        Rails.logger.error "Autenticação falhou para token: #{token}"
        return [401, { "Content-Type" => "application/json" }, [{ error: "Unauthorized" }.to_json]]
      end
    end
  
    @app.call(env)
  end
  

  private

  def protected_route?(path)
    !path.start_with?('/login', '/signup', '/assets')
  end

  def valid_token?(token)
    response = RestClient.get(
      "http://auth_service:4000/auth/validate",
      { Authorization: "Bearer #{token}" }
    )
    JSON.parse(response.body)["valid"]
  rescue RestClient::Unauthorized, RestClient::Forbidden
    false
  rescue RestClient::Exceptions::OpenTimeout, RestClient::Exceptions::ReadTimeout => e
    Rails.logger.error "Timeout ao validar token: #{e.message}"
    false
  rescue StandardError => e
    Rails.logger.error "Erro inesperado ao validar token: #{e.message}"
    false
  end
end
