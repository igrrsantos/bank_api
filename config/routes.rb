Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_for :users,
                 path: 'auth',
                 path_names: {
                   sign_in: 'login',
                   sign_out: 'logout',
                   registration: 'signup'
                 },
                 controllers: {
                   registrations: 'registrations',
                   sessions: 'sessions'
                 }

      resources :bank_accounts, only: [:create]
      resources :transactions, only: [:create]
      get '/bank_accounts/balance', to: 'bank_accounts#balance'
      post '/bank_accounts/deposit', to: 'bank_accounts#deposit'
      get '/bank_accounts/bank_statement', to: 'bank_accounts#bank_statement'
      # # Realizar transferência
      # POST /api/v1/transferencias
      # # Agendar transferência
      # POST /api/v1/transferencias/agendada
    end
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
