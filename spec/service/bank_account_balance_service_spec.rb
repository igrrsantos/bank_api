require 'rails_helper'

RSpec.describe BankAccountBalanceService do
  describe '#call' do
    let(:user) { create(:user) }
    let(:bank_account) { create(:bank_account, user_id: user.id) }

    context 'when the bank account exists and has no errors' do
      it 'returns Success with the bank account' do
        service = described_class.new
        result = service.call({ id: bank_account.id, user_id: user.id })

        expect(result).to be_success
        expect(result.value!).to eq(bank_account)
      end
    end

    context 'when the bank account has errors' do
      it 'returns Failure with errors' do
        service = described_class.new
        result = service.call(id: 123)

        expect(result).to be_failure
        expect(result.failure).to eq('Conta de origem não pertence ao usuário')
      end
    end
  end
end
