# frozen_string_literal: true

redis_objects_url = ENV['REDIS_OBJECTS_URL'] || ENV['REDIS_URL'] || 'redis://localhost'
$redis_objects = Redis.new(url: redis_objects_url)
Redis::Objects.redis = $redis_objects


redis_words_url = ENV['REDIS_WORDS_URL'] || ENV['REDIS_URL'] || 'redis://localhost'
$redis_words = Redis.new(url: redis_words_url)

redis_pages_url = ENV['REDIS_PAGES_URL'] || ENV['REDIS_URL'] || 'redis://localhost'
$redis_pages = Redis.new(url: redis_pages_url)


