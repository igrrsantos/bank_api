module Api
  module V1
    class TransactionsController < ApplicationController
      def create
        valid_params = valid_attributes(CreateTransactionContract, params[:transaction])

        result = CreateTransactionService.new(valid_params.merge(user_id: current_user_id)).call

        if result.success?
          render json: TransactionSerializer.new(result.value!).as_json
        else
          render json: { errors: result.failure }, status: :unprocessable_entity
        end
      end

      def schedule
        valid_params = valid_attributes(ScheduleTransactionContract, params[:transaction])

        result = ScheduleTransactionService.new(valid_params.merge(user_id: current_user_id)).call

        if result.success?
          render status: :no_content
        else
          render json: { errors: result.failure }, status: :unprocessable_entity
        end
      end
    end
  end
end
