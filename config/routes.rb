Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :pages do
    member do
      put 'download'
      put 'download_links'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
