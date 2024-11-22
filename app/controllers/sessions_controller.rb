# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  # skip_before_action :authenticate_request, only: %i[new create]

  def new
    # Renderiza a página de login
  end

  def create
    Rails.logger.info "Iniciando login para o email: #{params[:email]}"
    response = HTTP.post("http://auth_service:4000/auth/login", json: { email: params[:email], password: params[:password] })
  
    if response.status.success?
      token_data = JSON.parse(response.body.to_s)
      if token_data["token"].present?
        session[:jwt] = token_data["token"]
        Rails.logger.info "Login bem-sucedido para o email: #{params[:email]}"
        redirect_to root_path, notice: 'Login realizado com sucesso!'
      else
        Rails.logger.error "Token inválido recebido: #{token_data}"
        flash[:alert] = 'Erro no serviço de autenticação. Tente novamente mais tarde.'
        render :new
      end
    else
      Rails.logger.error "Falha no login para o email: #{params[:email]}. Resposta: #{response.body.to_s}"
      flash[:alert] = 'Email ou senha inválidos.'
      render :new
    end
  rescue HTTP::ConnectionError => e
    Rails.logger.error "Erro ao conectar com auth_service: #{e.message}"
    flash[:alert] = 'Erro ao conectar ao serviço de autenticação. Tente novamente mais tarde.'
    render :new
  end

  def destroy
    session[:jwt] = nil
    redirect_to login_path, notice: 'Logout realizado com sucesso.'
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end
