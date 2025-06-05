class BankAccountBalanceService
  include Dry::Monads[:result]

  def call(params)
    bank_account = bank_account_repository.find_by(params)

    raise ArgumentError, 'Conta de origem não pertence ao usuário' if bank_account.instance_of?(ActiveRecord::RecordNotFound)

    Success(bank_account)
  rescue StandardError => e
    Failure(e.message)
  end

  private

  def bank_account_repository
    @bank_account_repository ||= BankAccountRepository.new
  end
end
