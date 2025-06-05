class BankStatementContract < Dry::Validation::Contract
  params do
    required(:id).filled(:string)
    optional(:page).value(:string)
    optional(:per_page).value(:string)
    optional(:start_date).value(:string)
    optional(:end_date).value(:string)
    optional(:min_amount).value(:string)
    optional(:sent).value(:bool)
  end
end
