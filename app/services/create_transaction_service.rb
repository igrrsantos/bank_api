class CreateTransactionService
  include Dry::Monads[:result]
  def initialize(params)
    @origin_account_params = {
      user_id: params.delete(:user_id),
      id: params[:origin_account_id]
    }
    @params = params
  end

  def call
    origin_account = bank_account_repository.find_by(origin_account_params)

    return Failure(origin_account.errors) if origin_account.errors.any?

    transaction = transaction_repository.new_entity(params.merge(transaction_date))
    transaction_repository.save(transaction)

    return Failure(transaction.errors) if transaction.errors.any?

    Success(transaction)
  end

  private

  attr_reader :origin_account_params, :params

  def bank_account_repository
    @bank_account_repository ||= BankAccountRepository.new
  end

  def transaction_repository
    @transaction_repository ||= TransactionRepository.new
  end

  def transaction_date
    { transaction_date: DateTime.now }
  end
end
