class BankStatementContract < Dry::Validation::Contract
  params do
    required(:origin_account_id).filled(:string)
  end
end
