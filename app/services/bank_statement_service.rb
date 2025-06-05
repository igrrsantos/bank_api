class BankStatementService
  include Dry::Monads[:result]
  def initialize(params)
    @bank_account_params = {
      user_id: params.delete(:user_id),
      id: params[:bank_account_id]
    }
    @params = {
      bank_account_id: params[:bank_account_id],
      start_date: params[:start_date],
      end_date: params[:end_date],
      min_amount: params[:min_amount],
      sent: params[:sent],
      pagy_params: {
        page: params[:page].to_i,
        items: params[:per_page].to_i
      }
    }.compact
  end

  def call
    bank_account = bank_account_repository.find_by(bank_account_params)

    return Failure(bank_account.errors) if bank_account.errors.any?

    parse_period_attrs
    pagy, transaction = transaction_repository.where(params)

    [pagy, Success(transaction)]
  end

  private

  attr_reader :bank_account_params, :params, :pagy_params

  def parse_period_attrs
    if params[:start_date].present? && params[:end_date].present?
      params[:date] = params[:start_date].to_datetime.beginning_of_day..params[:end_date].to_datetime.end_of_day
    end

    params.delete(:start_date)
    params.delete(:end_date)
  end

  def bank_account_repository
    @bank_account_repository ||= BankAccountRepository.new
  end

  def transaction_repository
    @transaction_repository ||= TransactionRepository.new
  end
end
