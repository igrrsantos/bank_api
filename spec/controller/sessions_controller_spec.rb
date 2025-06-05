require 'swagger_helper'

RSpec.describe 'Auth API', type: :request do
  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user_id).and_return(user.id)
  end

  path '/api/v1/auth/login' do
    post 'Performs user login' do
      tags 'Auth'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user_param, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, format: :email },
              password: { type: :string }
            },
            required: %w[email password]
          }
        },
        required: ['user']
      }

      response '200', 'valid credentials' do
        let!(:user) { create(:user) }
        let(:user_param) do
          {
            user: {
              email: user.email,
              password: user.password
            }
          }
        end

        run_test! do |response|
          expect(json).to include(
            'id' => user.id,
            'name' => user.name,
            'email' => user.email
          )
          expect(json['token']).to be_a(String)
          expect(json['token']).not_to be_empty
        end
      end

      response '422', 'invalid credentials' do
        let!(:user) { create(:user) }
        let(:user_param) do
          {
            user: {
              email: user.email,
              password: 'wrongpassword'
            }
          }
        end

        run_test! do |response|
          expect(json).to eq({ 'errors' => 'Invalid email or password' })
        end
      end

      response '422', 'contract validation errors' do
        let(:user_param) { { user: { email: 'a', password: 'a' } } }

        run_test! do |response|
          expect(json['errors']).not_to be_empty
        end
      end
    end
  end
end
