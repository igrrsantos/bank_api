class TransactionRepository
  include Pagy::Backend

  def new_entity(attributes)
    Transaction.new(attributes)
  end

  def find(id)
    Transaction.find(id)
  end

  def save(transaction)
    transaction.save
  end

  def update(transaction, attributes)
    transaction.update(attributes)
  end

  def delete(transaction)
    transaction.destroy
  end

  def find_by(attributes)
    Transaction.find_by!(attributes)
  end

  def where(attributes)
    query = Transaction.where(destination_account_id: attributes[:origin_account_id])
                       .or(Transaction.where(origin_account_id: attributes[:origin_account_id]))

    # binding.pry
    pagy(query, page: 1, items: 2)
  end
end
