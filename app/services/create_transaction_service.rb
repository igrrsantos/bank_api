class CreateTransactionService
  include Dry::Monads[:result]
  def initialize(params)
    @amount = params[:amount]
    @origin_account_params = {
      user_id: params.delete(:user_id),
      id: params[:origin_account_id]
    }
    @idempotency_key = params.delete(:idempotency_key)
    @params = params
  end

  def call
    validations

    if idempotency_key
      immediate_transaction
    else
      scheduled_transaction
    end
  rescue StandardError => e
    Failure(e.message)
  end

  private

  attr_reader :amount, :origin_account_params, :idempotency_key, :params, :origin_account, :destination_account

  def validations
    @origin_account = bank_account_repository.find_by(origin_account_params)
    @destination_account = bank_account_repository.find(params[:destination_account_id])

    raise ArgumentError, 'Conta de origem não pertence ao usuário' if origin_account.errors.any?
    raise ArgumentError, 'Valor da transferência deve ser positivo' if amount <= 0
    raise ArgumentError, 'Conta de origem e destino devem ser diferentes' if origin_account.id == destination_account.id
    raise StandardError, 'Saldo insuficiente na conta de origem' if origin_account.balance < amount
  end

  def immediate_transaction
    raise ArgumentError, 'Idempotency key is required' unless idempotency_key

    idempotency_service = IdempotencyService.new
    idempotency_service.fetch_or_store(idempotency_key) do
      ActiveRecord::Base.transaction do
        bank_account_repository.update(origin_account, balance: origin_account.balance.to_f - amount.to_f)
        bank_account_repository.update(destination_account, balance: destination_account.balance.to_f + amount.to_f)

        transaction = transaction_repository.new_entity(params.merge(transaction_date))
        transaction_repository.save(transaction)

        raise ArgumentError, 'Erro ao salvar transação' if transaction.errors.any?

        Success(transaction)
      end
    end
  end

  def scheduled_transaction
    ActiveRecord::Base.transaction do
      bank_account_repository.update(origin_account, balance: origin_account.balance.to_f - amount.to_f)
      bank_account_repository.update(destination_account, balance: destination_account.balance.to_f + amount.to_f)

      transaction = transaction_repository.new_entity(params.merge(transaction_date))
      transaction_repository.save(transaction)

      raise ArgumentError, 'Erro ao salvar transação' if transaction.errors.any?

      Success(transaction)
    end
  end

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
