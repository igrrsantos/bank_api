Rails.application.routes.draw do
  require 'sidekiq/web'

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
      get '/bank_accounts/balance', to: 'bank_accounts#balance'
      post '/bank_accounts/deposit', to: 'bank_accounts#deposit'
      get '/bank_accounts/bank_statement', to: 'bank_accounts#bank_statement'
      get '/bank_accounts/bank_statement', to: 'bank_accounts#bank_statement'

      resources :transactions, only: [:create]
      post '/transactions/schedule', to: 'transactions#schedule'
    end
  end

  mount Sidekiq::Web => '/sidekiq'
  get 'up' => 'rails/health#show', as: :rails_health_check
end
