class BankAccountRepository
  def new_entity(attributes)
    BankAccount.new(attributes)
  end

  def find(id)
    BankAccount.find(id)
  end

  def save(bank_account)
    bank_account.save
  end

  def update(bank_account, attributes)
    bank_account.update(attributes)
  end

  def delete(bank_account)
    bank_account.destroy
  end

  def find_by(attributes)
    BankAccount.find_by!(attributes)
  end
end
