source "https://rubygems.org"

ruby "3.2.9"

# Framework principal
gem "rails", "~> 7.1.0"
gem "puma", "~> 6.0"
gem "pg"
gem "redis", "~> 5.0"
gem "sidekiq", "~> 7.3"
gem "sidekiq-cron", "~> 1.12"
gem "sidekiq-throttled", "~> 1.0.0"
gem "active_model_serializers"
gem "activerecord-import"
gem "bootsnap", require: false
gem "paranoia"
gem "faraday"
gem "pry-rails"
gem "rack-cors"
gem 'sprockets-rails'
gem "rack-timeout"

gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails", "~> 6.0"
end

group :test do
  gem "rack-test", require: "rack/test"
  gem "rspec-its"
  gem "rspec_junit_formatter"
  gem "webmock"
  gem "shoulda-matchers", "~> 5.0"
end

group :development do
  gem "listen", "~> 3.3"
  gem "spring"
  gem "spring-watcher-listen"
  gem "spring-commands-rspec"
  gem "dotenv-rails"
end
