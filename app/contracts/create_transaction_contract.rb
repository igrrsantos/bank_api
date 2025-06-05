class CreateTransactionContract < Dry::Validation::Contract
  params do
    required(:origin_account_id).filled(:string)
    required(:destination_account_id).filled(:string)
    required(:amount).filled(:float)
    required(:description).filled(:string)
  end
end
