class CreateUserSessionService
  include Dry::Monads[:result]

  def call(user_params)
    user = user_repository.find_by(email: user_params[:email].downcase)

    return Failure('Invalid email or password') unless user
    return Failure('Invalid email or password') unless user&.valid_password?(user_params[:password])

    Success({ user: user, token: user.generate_jwt })
  rescue StandardError => e
    Failure('Invalid email or password')
  end

  def user_repository
    @user_repository ||= UserRepository.new
  end
end
