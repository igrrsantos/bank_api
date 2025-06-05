class BankAccountBalanceContract < Dry::Validation::Contract
  params do
    required(:id).filled(:string)
  end
end
