PostRocket::Application.routes.draw do
  root to: 'main#index'
  
  # standard CRUD
  resources :pages, only: [:index, :show, :update]
  
  # facebook real-time (POST/GET)
  resources :facebook_updates, only: [:create, :index]

  # authentication stuff
  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'logout', to: 'sessions#destroy', as: 'logout'
end
