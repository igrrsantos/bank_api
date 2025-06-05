class CreateBankAccountContract < Dry::Validation::Contract
  params do
    required(:bank_number).filled(:string)
    required(:bank_agency_number).filled(:string)
  end
end
