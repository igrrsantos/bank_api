class CreateTransactionJob < ApplicationJob
  queue_as :default

  def perform(args)
    CreateTransactionService.new(args).call
  end
end
