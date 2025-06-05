class ScheduleTransactionService
  include Dry::Monads[:result]
  def initialize(params)
    @run_on = params.delete(:run_on)
    @params = params
  end

  def call
    CreateTransactionJob.set(wait_until: run_on.to_datetime).perform_later(params)
    Success()
  rescue StandardError => e
    Failure(e.message)
  end

  private

  attr_reader :run_on, :params
end
