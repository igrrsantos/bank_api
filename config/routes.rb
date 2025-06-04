Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    namespace :v1 do
      # Criar usuário
      POST /api/v1/users
      #Login
      POST /api/v1/auth/login
      # Consultar saldo
      GET /api/v1/conta/saldo
      # Realizar transferência
      POST /api/v1/transferencias
      # Agendar transferência
      POST /api/v1/transferencias/agendada
      # Listar extrato
      GET /api/v1/extrato
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
