# frozen_string_literal: true

redis_url = ENV['REDIS_OBJECTS_URL']
redis_url ||= ENV['REDIS_URL']
redis_url ||= 'redis://localhost'

Redis::Objects.redis = Redis.new(url: redis_url)
