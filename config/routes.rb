Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :pages do
    collection do
      get 'statistics'
    end

    member do
      put 'download'
      put 'download_links'
    end
  end

  resources :words do
    collection do
      put 'create_words'
    end

    member do
      get 'query'
    end
  end
end
