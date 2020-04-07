# frozen_string_literal: true

redis_url = ENV.fetch('REDIS_OBJECTS_URL', 'REDIS_URL', 'redis://localhost')
Redis::Objects.redis = Redis.new(url: redis_url)
