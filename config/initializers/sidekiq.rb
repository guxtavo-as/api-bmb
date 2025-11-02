require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq/cron/web'
require 'sidekiq/throttled'
Sidekiq::Throttled.setup!


Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] }

  config.on(:startup) do
    schedule_file = "config/scheduler/#{Rails.env}.yml"

    if File.exist?(schedule_file)
      Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file) || {}
    end
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end

Sidekiq.default_job_options = { backtrace: true, retry: 0 }
