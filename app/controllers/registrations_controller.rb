class RegistrationsController < Devise::RegistrationsController
  respond_to :json
  skip_before_action :authenticate_user!, only: [:create]

  def create
    build_resource(sign_up_params)

    resource.save
    if resource.persisted?
      render json: { message: 'User signed up successfully', user: resource }, status: :created
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :cpf, :name)
  end
end