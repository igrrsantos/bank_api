class SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_action :authenticate_user!, only: [:create]

  def create
    user_params = CreateUserSessionContract.new.call(params[:user])
    
    if user_params.failure?
      render json: { errors: user_params.errors.to_h }, status: :unprocessable_entity
      return
    end

    result = CreateUserSessionService.new.call(user_params)
  
    if result.success?
      render json: UserSerializer.new(result.value!).as_json
    else
      render json: { errors: result.failure }, status: :unprocessable_entity
    end
  end

  def destroy
    sign_out(current_user)
    render json: { message: 'Logged out successfully' }, status: :ok
  end
end