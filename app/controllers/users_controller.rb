class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[new create]

  def new
    # Render registration form
  end

  def create
    response = RestClient.post(
      "http://auth_service:4000/auth/register",
      user_params.to_json,
      { content_type: :json, accept: :json }
    )

    if response.code == 201
      flash[:notice] = 'User registered successfully! Please log in.'
      redirect_to login_path
    else
      @errors = JSON.parse(response.body)['errors']
      flash.now[:alert] = @errors.join(', ')
      render :new, status: :unprocessable_entity
    end
  rescue RestClient::ExceptionWithResponse => e
    Rails.logger.error "Error connecting to auth_service: #{e.message}"
    flash.now[:alert] = 'Error connecting to the authentication service. Please try again later.'
    render :new, status: :service_unavailable
  end

  private

  def user_params
    if params[:user]
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    else
      params.permit(:name, :email, :password, :password_confirmation)
    end
  end
end
