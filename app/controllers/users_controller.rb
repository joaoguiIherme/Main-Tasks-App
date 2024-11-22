class UsersController < ApplicationController
  # skip_before_action :authenticate_request, only: %i[new create]
  def new
    @user = User.new
  end

  def create
    response = HTTP.post("http://auth_service:4000/auth/register", json: user_params)

    if response.status.success?
      flash[:notice] = 'Usuário registrado com sucesso! Faça login para continuar.'
      redirect_to login_path
    else
      @errors = JSON.parse(response.body.to_s)["errors"]
      flash[:alert] = @errors.join(', ')
      render :new
    end
  rescue HTTP::ConnectionError => e
    Rails.logger.error "Erro ao conectar com auth_service: #{e.message}"
    flash[:alert] = 'Erro ao conectar ao serviço de autenticação. Tente novamente mais tarde.'
    render :new
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
