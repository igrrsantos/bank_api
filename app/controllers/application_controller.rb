include Pagy::Backend

class ApplicationController < ActionController::API
  respond_to :json
  before_action :authenticate_user!
  before_action :handle_options_request

  def valid_attributes(contract_class, params)
    result = contract_class.new.call(params&.to_unsafe_hash)

    return result.values.data if result.success?

    raise 'ValidationContracts'
  end

  def authenticate_user!
    auth_header = request.headers['Authorization']

    if auth_header.blank?
      render json: { error: 'Authorization header missing' }, status: :unauthorized
      return
    end

    token = auth_header.split(' ').last

    begin
      secret = Devise::JWT.config.secret || Rails.application.credentials.secret_key_base
      decoded = JWT.decode(token, secret, true, algorithm: 'HS256')

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

  def current_user_id
    @current_user.id
  end

  def serialize_data(data, serializer_class)
    ActiveModel::Serializer::CollectionSerializer.new(
      data,
      serializer: serializer_class
    )
  end

  def pagy_metadata(pagy)
    {
      current_page: pagy.page,
      items_per_page: pagy.vars[:items],
      total_pages: pagy.last,
      total_items: pagy.in
    }
  end
end
