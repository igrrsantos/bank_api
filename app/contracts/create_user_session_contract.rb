Dry::Validation.load_extensions(:monads)

class CreateUserSessionContract < Dry::Validation::Contract
  params do
    required(:email).filled(:string)
    required(:password).filled(:string)
  end
end