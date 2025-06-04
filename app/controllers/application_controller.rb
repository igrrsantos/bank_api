class ApplicationController < ActionController::API
  respond_to :json
  before_action :authenticate_user!
  before_action :handle_options_request

  def authenticate_user!
    auth_header = request.headers['Authorization']

    if auth_header.blank?
      render json: { error: 'Authorization header missing' }, status: :unauthorized
      return
    end

    token = auth_header.split(' ').last

    begin
      # Use a chave secreta do Devise-JWT (ou Rails.application.credentials.secret_key_base)
      secret = Devise::JWT.config.secret || Rails.application.credentials.secret_key_base
      decoded = JWT.decode(token, secret, true, algorithm: 'HS256')

      # Ajuste para o payload correto (sub ou user_id)
      user_id = decoded.first['sub'] || decoded.first['user_id']
      @current_user = User.find(user_id)
    rescue JWT::ExpiredSignature
      render json: { error: 'Token expirado' }, status: :unauthorized
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { error: 'Token inválido' }, status: :unauthorized
    end
  end

  def handle_options_request
  head :ok if request.method == 'OPTIONS'
  end

  def current_user
    @current_user
  end
end
