class BankAccountSerializer < ActiveModel::Serializer
  attributes :id, :bank_number, :bank_agency_number, :balance
end
