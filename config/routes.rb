Rails.application.routes.draw do
  resources :pages do
    member do
      put 'download'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
