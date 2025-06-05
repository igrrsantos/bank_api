class CreateBankAccountService
  include Dry::Monads[:result]

  def call(params)
    bank_account = bank_account_repository.new_entity(params)
    bank_account_repository.save(bank_account)

    return Failure(bank_account.errors) if bank_account.errors.any?

    Success(bank_account)
  end

  private

  def bank_account_repository
    @bank_account_repository ||= BankAccountRepository.new
  end
end
