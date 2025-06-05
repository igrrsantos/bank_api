JWT_SECRET = ENV['JWT_SECRET'] || Rails.application.credentials[:jwt_secret] || 'segredo_padrão_para_dev'
