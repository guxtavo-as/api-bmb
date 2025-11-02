class ApplicationJob
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  sidekiq_options retry: 0, backtrace: true
end
