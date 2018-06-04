Rails.application.routes.draw do
  get 'passwordresets/new'

  get 'passwordresets/edit'

  get 'sessions/new'

  get '/hello', to: 'static_pages#hello', as: 'help' # در این صورت فقط ادرس اینترنتی را نمایش می دهد و ریدایرکت نمی شود
  get '/about', to: 'static_pages#about'
  get '/tamas', to: 'static_pages#tamas'
  get '/contact', to: 'static_pages#contact'
  root 'static_pages#home'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  resources :users
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users do
     member do
        get :following, :followers
     end
  end
  resources :accont_activations, only: [:edit]
  resources :passwordresets, only: [:new, :create, :edit, :update]
  resources :micro_posts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
