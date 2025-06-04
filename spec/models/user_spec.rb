require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:cpf) }

    it 'validates uniqueness of cpf' do
      user1 = create(:user)
      user2 = build(:user, cpf: user1.cpf, email: 'teste@teste.com')

      expect(user2).not_to be_valid
      expect(user2.errors[:cpf]).to include('has already been taken')
    end

    context 'when CPF format is invalid' do
      invalid_cpfs = ['123.456.789-00', '111.111.111-11', '12345678900', 'invalid']

      invalid_cpfs.each do |invalid_cpf|
        it "#{invalid_cpf} should be invalid" do
          user = build(:user, cpf: invalid_cpf)
          expect(user).not_to be_valid
          expect(user.errors[:cpf]).to include('não é válido')
        end
      end
    end

    context 'when CPF format is valid' do
      valid_cpfs = ['138.474.630-71', '889.074.610-66', '78788279073']

      valid_cpfs.each do |valid_cpf|
        it "#{valid_cpf} should be valid" do
          user = build(:user, cpf: valid_cpf)
          expect(user).to be_valid
        end
      end
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:bank_accounts) }
  end

  describe 'Devise modules' do
    it 'should include database_authenticatable module' do
      expect(described_class.devise_modules).to include(:database_authenticatable)
    end

    it 'should include registerable module' do
      expect(described_class.devise_modules).to include(:registerable)
    end

    it 'should include recoverable module' do
      expect(described_class.devise_modules).to include(:recoverable)
    end

    it 'should include rememberable module' do
      expect(described_class.devise_modules).to include(:rememberable)
    end

    it 'should include validatable module' do
      expect(described_class.devise_modules).to include(:validatable)
    end

    it 'should include jwt_authenticatable module' do
      expect(described_class.devise_modules).to include(:jwt_authenticatable)
    end
  end

  describe 'JWT revocation' do
    let(:user) { create(:user) }

    it 'responds to jwt_revocation_strategy' do
      expect(described_class).to respond_to(:jwt_revocation_strategy)
    end

    it 'uses self as jwt_revocation_strategy' do
      expect(described_class.jwt_revocation_strategy).to eq(described_class)
    end
  end

  describe '#valid_cpf_format' do
    context 'when CPF is valid' do
      it 'does not add errors' do
        user = create(:user)
        user.valid?
        expect(user.errors[:cpf]).to be_empty
      end
    end

    context 'when CPF is invalid' do
      it 'adds error to cpf' do
        user = build(:user, cpf: '111.111.111-11')
        user.valid?
        expect(user.errors[:cpf]).to include('não é válido')
      end
    end
  end
end