require 'rails_helper'
include Dry::Monads[:result]

RSpec.describe 'api/v1/auth SessionsController requests', type: :request do
  describe 'POST /api/v1/auth/login' do
    subject(:login) do
      post '/api/v1/auth/login',
           params: login_params
    end

    context 'with valid credentials' do
      let!(:user) { create(:user) }
      let!(:login_params) do
        {
          user: {
            email: user.email,
            password: user.password
          }
        }
      end

      it 'returns a successful response with user and token' do
        login
        expect(response).to have_http_status(:ok)
        expect(json).to include(
          {
            'id' => user.id,
            'name' => user.name,
            'email' => user.email
          }
        )
        expect(json['token']).to be_a(String)
        expect(json['token']).not_to be_empty
      end
    end

    context 'with invalid credentials' do
      let!(:login_params) do
        {
          user: {
            email: 'teste@teste.com',
            password: 'password123'
          }
        }
      end

      it 'returns an error response' do
        login
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ 'errors' => 'Invalid email or password' })
      end
    end

    context 'with invalid contract params' do
      let!(:login_params) { { user: { email: '', password: '' } } }

      it 'returns contract validation errors' do
        expect { login }.to raise_error
      end
    end
  end
end
