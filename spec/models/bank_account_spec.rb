require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  let(:user) { create(:user) }
  let(:valid_attributes) do
    {
      user: user,
      bank_number: '12345678',
      bank_agency_number: '0001',
      balance: 1000.00
    }
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      account = create(:bank_account)
      expect(account).to be_valid
    end

    subject { build(:bank_account, user: create(:user)) }

    it { should validate_presence_of(:bank_number) }
    it { should validate_uniqueness_of(:bank_number).case_insensitive }
    it { should validate_presence_of(:bank_agency_number) }
    it { should validate_presence_of(:balance) }
    it { should validate_numericality_of(:balance) }

    context 'when bank_number is not unique' do
      before { create(:bank_account, bank_number: '12345678') }

      it 'is invalid' do
        account = build(:bank_account, user: user, bank_number: '12345678')
        expect(account).not_to be_valid
        expect(account.errors[:bank_number]).to include('has already been taken')
      end
    end

    context 'when balance is negative' do
      it 'is valid (permite saldo negativo)' do
        account = build(:bank_account, user: user, balance: -100.00)
        expect(account).to be_valid
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'scopes' do
    let!(:account1) { create(:bank_account, balance: 500.00) }
    let!(:account2) { create(:bank_account, balance: 1000.00) }
    let!(:account3) { create(:bank_account, balance: -200.00) }

    describe '.positive_balance' do
      it 'returns only accounts with positive balance' do
        expect(BankAccount.positive_balance).to contain_exactly(account1, account2)
      end
    end

    describe '.negative_balance' do
      it 'returns only accounts with negative balance' do
        expect(BankAccount.negative_balance).to contain_exactly(account3)
      end
    end
  end
end