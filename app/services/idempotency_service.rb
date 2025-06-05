require 'redis'

class IdempotencyService
  def initialize
    @redis = Redis.new
  end

  def fetch_or_store(key, ttl: 3_600)
    existing_response = @redis.get(key)
    raise ArgumentError, 'Erro ao salvar transação' if existing_response

    response = yield
    @redis.set(key, response.to_json, ex: ttl)
    response
  end
end
