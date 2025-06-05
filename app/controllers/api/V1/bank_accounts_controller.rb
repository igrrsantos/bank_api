module Api
  module V1
    class BankAccountsController < ApplicationController
      def create
        valid_params = valid_attributes(CreateBankAccountContract, params[:bank_account])

        result = CreateBankAccountService.new.call(valid_params.merge(user_id: current_user_id))

        if result.success?
          render json: result.value!,
                 each_serializer: BankAccountSerializer,
                 status: :created
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

        paginated_result, pagy = BankStatementService.new(valid_params.merge(user_id: current_user_id)).call

        if paginated_result.success?
          response_data = {
            data: serialize_data(paginated_result.value!, BankStatementSerializer)
          }

          response_data[:pagination] = pagy_metadata(pagy) if pagy.present?
          render json: response_data, status: :ok
        else
          render json: { errors: result.failure }, status: :unprocessable_entity
        end
      end

      def deposit
        valid_params = valid_attributes(DepositContract, params[:bank_account])

        result = DepositService.new(valid_params.merge(user_id: current_user_id)).call

        if result.success?
          render json: BankAccountSerializer.new(result.value!).as_json, status: :created
        else
          render json: { errors: result.failure }, status: :unprocessable_entity
        end
      end
    end
  end
end
