class BankStatementSerializer < ActiveModel::Serializer
  attributes :id, :origin_account_id, :destination_account_id, :amount, :description, :localized_transaction_date

  def localized_transaction_date
    I18n.locale = :'pt-BR'
    I18n.l(object.transaction_date, format: :long)
  end
end
