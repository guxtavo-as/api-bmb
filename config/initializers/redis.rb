$redis_pool = ConnectionPool.new(size: 10, timeout: 5) do
  if url = ENV['REDIS_CACHE_URL']
    Redis.new(url: url)
  else
    Redis.new
  end
end
