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
      # # Criar usuário
      # POST /api/v1/users
      # #Login
      # POST /api/v1/auth/login
      # # Consultar saldo
      # GET /api/v1/conta/saldo
      # # Realizar transferência
      # POST /api/v1/transferencias
      # # Agendar transferência
      # POST /api/v1/transferencias/agendada
      # # Listar extrato
      # GET /api/v1/extrato
    end
  end
  get "up" => "rails/health#show", as: :rails_health_check

end
