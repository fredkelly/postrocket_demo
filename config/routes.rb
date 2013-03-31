PostRocket::Application.routes.draw do
  root to: 'welcome#index'
  
  # units
  resources :pages, only: [:index, :show, :update]

  # authentication stuff
  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'logout', to: 'sessions#destroy', as: 'logout'
end
