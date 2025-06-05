class BankStatementService
  include Dry::Monads[:result]
  def initialize(params)
    @bank_account_params = {
      user_id: params.delete(:user_id),
      id: params[:origin_account_id]
    }
    @params = {
      origin_account_id: params[:origin_account_id]
    }
  end

  def call
    bank_account = bank_account_repository.find_by(bank_account_params)

    return Failure(bank_account.errors) if bank_account.errors.any?

    pagy, transaction = transaction_repository.where(params)
    binding.pry

    [pagy, Success(transaction)]
  end

  private

  attr_reader :bank_account_params, :params

  def bank_account_repository
    @bank_account_repository ||= BankAccountRepository.new
  end

  def transaction_repository
    @transaction_repository ||= TransactionRepository.new
  end
end
