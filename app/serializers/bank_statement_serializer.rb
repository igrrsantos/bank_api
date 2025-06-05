class BankStatementSerializer < ActiveModel::Serializer
  attributes :id, :origin_account_id, :destination_account_id, :amount, :description
end
