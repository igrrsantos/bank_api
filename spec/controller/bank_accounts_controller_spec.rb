require 'rails_helper'
require 'swagger_helper'

RSpec.describe Api::V1::BankAccountsController, type: :request do
  let!(:user) { create(:user) }
  let(:headers) { { 'Authorization' => "Bearer #{user.generate_jwt}" } }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user_id).and_return(user.id)
  end

  path '/api/v1/bank_accounts' do
    post 'Creates a bank account' do
      tags 'BankAccounts'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :bank_account, in: :body, schema: {
        type: :object,
        properties: {
          bank_account: {
            type: :object,
            properties: {
              bank_number: { type: :string },
              bank_agency_number: { type: :string }
            },
            required: [ 'bank_number', 'bank_agency_number' ]
          }
        },
        required: [ 'bank_account' ]
      }
      parameter name: :Authorization, in: :header, type: :string, required: true

      let(:Authorization) { headers['Authorization'] }

      response '201', 'bank account created' do
        let(:bank_account) do
          {
            bank_account: {
              bank_number: 'asdasasda',
              bank_agency_number: '0001'
            }
          }
        end

        run_test! do |response|
          expect(json).to include(
            'bank_number' => 'asdasasda',
            'bank_agency_number' => '0001',
            'balance' => '0.0'
          )
        end
      end

      response '422', 'bank_number already exists' do
        let!(:existing_bank_account) { create(:bank_account, user: user) }
        let(:bank_account) do
          {
            bank_account: {
              bank_number: existing_bank_account.bank_number,
              bank_agency_number: '0001'
            }
          }
        end

        run_test! do |response|
          expect(json['errors']).not_to be_empty
          expect(json).to eq(
            { 'errors' => { 'bank_number' => ['has already been taken'] } }
          )
        end
      end
    end
  end

  path '/api/v1/bank_accounts/{id}/balance' do
    get 'Returns the account balance' do
      tags 'BankAccounts'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'Bank Account ID'
      parameter name: :Authorization, in: :header, type: :string, required: true

      let(:Authorization) { headers['Authorization'] }
      let(:id) { bank_account.id }
      let!(:bank_account) { create(:bank_account, user: user) }

      response '200', 'returns the account balance' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            bank_number: { type: :string },
            bank_agency_number: { type: :string },
            balance: { type: :string }
          },
          required: [ 'id', 'bank_number', 'bank_agency_number', 'balance' ]

        run_test! do |response|
          expect(json).to eq(
            'id' => bank_account.id,
            'bank_number' => bank_account.bank_number,
            'bank_agency_number' => bank_account.bank_agency_number,
            'balance' => bank_account.balance.to_s
          )
        end
      end

      response '422', 'account not found or invalid' do
        let(:id) { 'asdas987' }

        schema type: :object,
          properties: {
            errors: { type: :string }
          },
          required: [ 'errors' ]

        run_test! do |response|
          expect(json).not_to be_empty
        end
      end
    end
  end

  path '/api/v1/bank_accounts/{id}/bank_statement' do
    get 'Returns the bank statement for the account' do
      tags 'BankAccounts'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'Bank Account ID'
      parameter name: :page, in: :query, type: :string, required: false, description: 'Page number'
      parameter name: :per_page, in: :query, type: :string, required: false, description: 'Items per page'
      parameter name: :Authorization, in: :header, type: :string, required: true

      let(:Authorization) { headers['Authorization'] }
      let!(:bank_account) { create(:bank_account, user: user) }
      let(:id) { bank_account.id }
      let!(:bank_account2) { create(:bank_account, user: user) }

      response '200', 'returns the bank statement without pagination' do
        let!(:transaction1) { create(:transaction, origin_account_id: bank_account.id, destination_account_id: bank_account2.id, amount: 100) }
        let!(:transaction2) { create(:transaction, origin_account_id: bank_account.id, destination_account_id: bank_account2.id, amount: 100) }

        run_test! do |response|
          expect(json).to have_key('data')
          expect(json['data']).to be_an(Array)
          expect(json).to_not have_key('pagination')
        end
      end

      response '200', 'returns paginated bank statement' do
        let(:page) { '1' }
        let(:per_page) { '1' }

        let!(:transaction1) { create(:transaction, origin_account_id: bank_account.id, destination_account_id: bank_account2.id, amount: 100) }
        let!(:transaction2) { create(:transaction, origin_account_id: bank_account.id, destination_account_id: bank_account2.id, amount: 100) }

        run_test! do |response|
          expect(json['data'].size).to eq(1)
          expect(json).to have_key('pagination')
        end
      end
    end
  end

  path '/api/v1/bank_accounts/deposit' do
    post 'Deposits value into a bank account' do
      tags 'BankAccounts'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          bank_account: {
            type: :object,
            properties: {
              value: { type: :string },
              id: { type: :string }
            },
            required: %w[value id]
          }
        },
        required: ['bank_account']
      }
      parameter name: :Authorization, in: :header, type: :string, required: true

      let(:Authorization) { headers['Authorization'] }
      let!(:bank_account) { create(:bank_account, user: user, balance: 100.0) }
      let(:origin_account_id) { bank_account.id }

      response '201', 'account with updated balance' do
        let!(:params) { { bank_account: { value: '50.0', id: origin_account_id.to_s } } }

        run_test! do |response|
          expect(json).to include(
            'id' => bank_account.id,
            'balance' => '150.0'
          )
        end
      end

      response '201', 'account with updated balance (created)' do
        let(:params) { { bank_account: { value: '50.0', id: origin_account_id.to_s } } }

        run_test! do |response|
          expect(json).to include(
            'id' => bank_account.id,
            'balance' => '150.0'
          )
        end
      end

      response '422', 'account not found or does not belong to user' do
        let(:params) { { bank_account: { value: '50.0', id: 'nonexistent' } } }

        run_test! do |response|
          expect(json['errors']).not_to be_empty
        end
      end
    end
  end
end
