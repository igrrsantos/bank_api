class DepositContract < Dry::Validation::Contract
  params do
    required(:id).filled(:string)
    required(:value).filled(:string)
  end
end
