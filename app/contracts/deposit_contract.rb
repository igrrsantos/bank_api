class DepositContract < Dry::Validation::Contract
  params do
    required(:origin_account_id).filled(:string)
    required(:value).filled(:string)
  end
end
