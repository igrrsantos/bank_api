class BankAccountRepository
  def new_entity(attributes)
    BankAccount.new(attributes)
  rescue StandardError => e
    e
  end

  def find(id)
    BankAccount.find(id)
  rescue StandardError => e
    e
  end

  def save(bank_account)
    bank_account.save
  rescue StandardError => e
    e
  end

  def update(bank_account, attributes)
    bank_account.update(attributes)
  rescue StandardError => e
    e
  end

  def delete(bank_account)
    bank_account.destroy
  rescue StandardError => e
    e
  end

  def find_by(attributes)
    BankAccount.find_by!(attributes)
  rescue StandardError => e
    e
  end
end
