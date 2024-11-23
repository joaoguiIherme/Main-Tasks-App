class SessionsController < ApplicationController
  skip_before_action :authenticate_request, only: %i[new create]

  def new
    # Render login form
  end

  def create
    begin
      response = RestClient.post(
        "http://auth_service:4000/auth/login",
        { email: params[:email], password: params[:password] }.to_json,
        { content_type: :json, accept: :json }
      )

      if response.code == 200
        token_data = JSON.parse(response.body)
        session[:jwt] = token_data['token'] # Armazenar token na sessão
        redirect_to root_path, notice: 'Login successful!'
      else
        flash.now[:alert] = 'Invalid email or password.'
        render :new
      end
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error "Error connecting to auth_service: #{e.message}"
      flash.now[:alert] = 'Error connecting to the authentication service. Please try again later.'
      render :new
    end
  end

  def destroy
    session[:jwt] = nil
    redirect_to login_path, notice: 'Logged out successfully.'
  end
end
