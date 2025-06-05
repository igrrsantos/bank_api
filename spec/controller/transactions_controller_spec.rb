require 'rails_helper'
require 'swagger_helper'

RSpec.describe Api::V1::TransactionsController, type: :request do
  let!(:user) { create(:user) }
  let(:headers) { { 'Authorization' => "Bearer #{user.generate_jwt}" } }
  path '/api/v1/transactions' do
    post 'Create a transaction (immediate)' do
      tags 'Transactions'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :transaction, in: :body, schema: {
        type: :object,
        properties: {
          transaction: {
            type: :object,
            properties: {
              origin_account_id: { type: :string },
              destination_account_id: { type: :string },
              amount: { type: :number },
              description: { type: :string },
              idempotency_key: { type: :string }
            },
            required: %w[origin_account_id destination_account_id amount description idempotency_key]
          }
        },
        required: ['transaction']
      }
      parameter name: :Authorization, in: :header, type: :string, required: true

      let(:Authorization) { headers['Authorization'] }
      let!(:origin_account) { create(:bank_account, user: user, balance: 500.0) }
      let!(:destination_account) { create(:bank_account, balance: 100.0) }

      response '200', 'transaction created' do
        let(:transaction) do
          {
            transaction: {
              origin_account_id: origin_account.id.to_s,
              destination_account_id: destination_account.id.to_s,
              amount: 100.0,
              description: 'Pagamento de serviço',
              idempotency_key: SecureRandom.uuid
            }
          }
        end

        run_test! do |response|
          expect(json).to include(
            'origin_account_id' => origin_account.id,
            'destination_account_id' => destination_account.id,
            'amount' => 100.0.to_s,
            'description' => 'Pagamento de serviço'
          )
        end
      end

      response '422', 'invalid parameters' do
        let(:transaction) do
          {
            transaction: {
              origin_account_id: origin_account.id.to_s,
              destination_account_id: origin_account.id.to_s,
              amount: -50.0,
              description: 'sd',
              idempotency_key: '2'
            }
          }
        end

        run_test! do |response|
          expect(json['errors']).not_to be_empty
        end
      end
    end
  end

  path '/api/v1/transactions/schedule' do
    post 'Schedule a transaction' do
      tags 'Transactions'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :transaction, in: :body, schema: {
        type: :object,
        properties: {
          transaction: {
            type: :object,
            properties: {
              origin_account_id: { type: :string },
              destination_account_id: { type: :string },
              amount: { type: :number },
              description: { type: :string },
              run_on: { type: :string, format: :date }
            },
            required: %w[origin_account_id destination_account_id amount description run_on]
          }
        },
        required: ['transaction']
      }
      parameter name: :Authorization, in: :header, type: :string, required: true

      let(:Authorization) { headers['Authorization'] }
      let!(:origin_account) { create(:bank_account, user: user, balance: 1000.0) }
      let!(:destination_account) { create(:bank_account, balance: 100.0) }

      response '204', 'transaction scheduled' do
        let(:transaction) do
          {
            transaction: {
              origin_account_id: origin_account.id.to_s,
              destination_account_id: destination_account.id.to_s,
              amount: 200.0,
              description: 'Agendamento de pagamento',
              run_on: (Date.today + 2.days).to_s
            }
          }
        end

        run_test!
      end

      response '422', 'invalid parameters for scheduling' do
        let(:transaction) do
          {
            transaction: {
              origin_account_id: origin_account.id.to_s,
              destination_account_id: origin_account.id.to_s,
              amount: 0.0,
              description: '2',
              run_on: 'asd'
            }
          }
        end

        run_test! do |response|
          expect(json['errors']).not_to be_empty
        end
      end
    end
  end
end
