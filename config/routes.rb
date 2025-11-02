require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
 
  mount ActionCable.server => '/cable'
  mount Sidekiq::Web => '/sidekiq'

  resources :topups, only: %i[index show create]
end
