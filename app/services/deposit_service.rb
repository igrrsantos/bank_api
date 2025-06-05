class DepositService
  include Dry::Monads[:result]
  def initialize(params)
    @bank_account_params = {
      user_id: params.delete(:user_id),
      id: params.delete(:id)
    }
    @params = params
  end

  def call
    bank_account = bank_account_repository.find_by(bank_account_params)

    raise ArgumentError, 'Conta de origem não pertence ao usuário' if bank_account.errors.any?

    bank_account_repository.update(bank_account, deposit_params(bank_account))

    Success(bank_account)
  rescue StandardError => e
    Failure(e)
  end

  private

  attr_reader :bank_account_params, :params

  def bank_account_repository
    @bank_account_repository ||= BankAccountRepository.new
  end

  def transaction_repository
    @transaction_repository ||= TransactionRepository.new
  end

  def deposit_params(bank_account)
    { balance: bank_account.balance.to_f + params[:value].to_f }
  end
end
