require 'swagger_helper'

RSpec.describe 'Auth API', type: :request do
  path '/api/v1/auth/signup' do
    post 'User registration' do
      tags 'Auth'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user_params, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name: { type: :string },
              email: { type: :string, format: :email },
              password: { type: :string },
              password_confirmation: { type: :string },
              cpf: { type: :string }
            },
            required: %w[name email password password_confirmation cpf]
          }
        },
        required: ['user']
      }

      response '201', 'user created' do
        let(:user_params) do
          {
            user: {
              name: 'João Silva',
              email: 'joao@email.com',
              password: 'supersecret',
              cpf: CPF.generate(true),
              password_confirmation: 'supersecret'
            }
          }
        end

        run_test! do |response|
          expect(json['user']).to include(
            'id' => kind_of(Integer),
            'name' => 'João Silva',
            'email' => 'joao@email.com'
          )
        end
      end

      response '422', 'email already taken' do
        let!(:existing_user) { create(:user, email: 'joao@email.com') }
        let(:user_params) do
          {
            user: {
              name: 'João Silva',
              email: 'joao@email.com',
              password: 'supersecret',
              password_confirmation: 'supersecret',
              cpf: CPF.generate(true)
            }
          }
        end

        run_test! do |response|
          expect(json['errors']).not_to be_empty
          expect(json['errors']).to eq(['Email já está em uso'])
        end
      end

      response '422', 'validation errors (invalid params)' do
        let(:user_params) do
          {
            user: {
              name: '',
              email: '',
              password: 'short',
              password_confirmation: 'different'
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
