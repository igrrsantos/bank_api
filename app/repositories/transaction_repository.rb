class TransactionRepository
  include Pagy::Backend

  def new_entity(attributes)
    Transaction.new(attributes)
  rescue StandardError => e
    e
  end

  def find(id)
    Transaction.find(id)
  rescue StandardError => e
    e
  end

  def save(transaction)
    transaction.save
  rescue StandardError => e
    e
  end

  def update(transaction, attributes)
    transaction.update(attributes)
  rescue StandardError => e
    e
  end

  def delete(transaction)
    transaction.destroy
  rescue StandardError => e
    e
  end

  def find_by(attributes)
    Transaction.find_by!(attributes)
  rescue StandardError => e
    e
  end

  def where(attributes)
    query = Transaction.where(destination_account_id: attributes[:bank_account_id])
                       .or(Transaction.where(origin_account_id: attributes[:bank_account_id]))

    query = query.where(amount: attributes[:min_amount]..) if attributes[:min_amount].present?
    query = query.where(transaction_date: attributes[:date]) if attributes[:date].present?

    if attributes[:sent] == true
      query = query.where(origin_account_id: attributes[:bank_account_id])
    elsif attributes[:sent] == false
      query = query.where(destination_account_id: attributes[:bank_account_id])
    end

    query = query.order(transaction_date: :desc)
    pagy(query, page: attributes[:pagy_params][:page],
                items: attributes[:pagy_params][:items], limit: attributes[:pagy_params][:items])
  rescue StandardError => e
    e
  end
end
