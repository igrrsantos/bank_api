module Api
  module V1
    class BankAccountsController < ApplicationController
      def create
        valid_params = valid_attributes(CreateBankAccountContract, params[:bank_account])

        result = CreateBankAccountService.new.call(valid_params.merge(user_id: current_user_id))

        if result.success?
          render json: result.value!,
                 each_serializer: BankAccountSerializer,
                 status: :ok
        else
          render json: { errors: result.failure }, status: :unprocessable_entity
        end
      end

      def balance
        valid_params = valid_attributes(BankAccountBalanceContract, params)

        result = BankAccountBalanceService.new.call(valid_params.merge(user_id: current_user_id))

        if result.success?
          render json: BankAccountSerializer.new(result.value!).as_json
        else
          render json: { errors: result.failure }, status: :unprocessable_entity
        end
      end

      def bank_statement
        valid_params = valid_attributes(BankStatementContract, params)

        pagy, paginated_result = BankStatementService.new(valid_params.merge(user_id: current_user_id)).call

        if paginated_result.success?
          render json: {
            data: serialize_data(paginated_result.value!, BankStatementSerializer),
            pagination: pagy_metadata(pagy)
          }, status: :ok
        else
          render json: { errors: result.failure }, status: :unprocessable_entity
        end
      end
    end
  end
end
