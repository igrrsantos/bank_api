class SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_action :authenticate_user!, only: [:create]

  def create
    valid_params = valid_attributes(CreateUserSessionContract, params[:user])

    result = CreateUserSessionService.new.call(valid_params)

    if result.success?
      render json: UserSerializer.new(result.value![:user], { token: result.value![:token] }).as_json
    else
      render json: { errors: result.failure }, status: :unprocessable_entity
    end
  end

  def destroy
    sign_out(current_user)
    render json: { message: 'Logged out successfully' }, status: :ok
  end
end