module Api
  module V1
    class TransactionsController < ApplicationController
      def create
        valid_params = valid_attributes(CreateTransactionContract, params[:bank_account])

        result = CreateTransactionService.new.call(valid_params.merge(user_id: current_user_id))

        if result.success?
          render json: TransactionSerializer.new(result.value!).as_json
        else
          render json: { errors: result.failure }, status: :unprocessable_entity
        end
      end
    end
  end
end
