class CreateUserSessionService
  include Dry::Monads[:result]

  def call(user_params)
    user = User.find_by(email: user_params[:email].downcase)
    
    return Failure("Invalid email or password") unless user
    return Failure("Invalid email or password") unless user.authenticate(user_params[:password])

    # Exemplo com JWT (adicione a gem 'jwt' no Gemfile)
    token = user.generate_jwt

    Success({ user: user, token: token })
  end

  private

  def generate_jwt(user)
    payload = { user_id: user.id, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end
end