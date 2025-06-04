module Api
  module V1
    class BankAccountsController < ApplicationController
      def create
        @bank_account = current_user.bank_accounts.new(bank_account_params)
        @bank_account.balance = 0.0      # Saldo inicial zero

        if @bank_account.save
          render json: {
            message: 'Conta bancária criada com sucesso',
            account: bank_account_response(@bank_account)
          }, status: :created
        else
          render json: {
            errors: @bank_account.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      private

      def bank_account_params
        params.require(:bank_account).permit(:bank_number, :bank_agency_number)
      end
    end
  end
end