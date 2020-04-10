Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :pages do
    member do
      put 'download'
      put 'download_links'
    end
  end

  resources :words
end
