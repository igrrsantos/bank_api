require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:origin_account) { create(:bank_account, balance: 1000.00, user: user1) }
  let(:destination_account) { create(:bank_account, balance: 500.00, user: user2) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      transaction = create(
        :transaction, origin_account: origin_account, destination_account: destination_account,
        amount: 100.00, description: 'Transferência entre contas', transaction_date: Time.current
      )
      expect(transaction).to be_valid
    end

    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).is_greater_than(0) }
    it { should validate_presence_of(:transaction_date) }
    it { should validate_length_of(:description).is_at_most(255) }

    context 'when amount is zero' do
      it 'is invalid' do
        transaction = build(
          :transaction, origin_account: origin_account, destination_account: destination_account,
          amount: 0, description: 'Transferência entre contas', transaction_date: Time.current
        )

        expect(transaction).not_to be_valid
        expect(transaction.errors[:amount]).to include('must be greater than 0')
      end
    end

    context 'when amount is negative' do
      it 'is invalid' do
        transaction = build(
          :transaction, origin_account: origin_account, destination_account: destination_account,
          amount: -100, description: 'Transferência entre contas', transaction_date: Time.current
        )

        expect(transaction).not_to be_valid
        expect(transaction.errors[:amount]).to include('must be greater than 0')
      end
    end

    context 'when origin and destination are the same' do
      it 'is invalid' do
        transaction = build(
          :transaction, origin_account: origin_account, destination_account: origin_account,
          amount: 100.00, description: 'Transferência entre contas', transaction_date: Time.current
        )

        expect(transaction).not_to be_valid
        expect(transaction.errors[:base]).to include('Origin and destination accounts must be different')
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:origin_account).class_name('BankAccount') }
    it { should belong_to(:destination_account).class_name('BankAccount') }
  end
end