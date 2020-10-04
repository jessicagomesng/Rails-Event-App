Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'welcome#home'
  get '/account', to: 'welcome#account'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  post '/logout', to: 'sessions#destroy'
  get '/auth/facebook/callback', to: 'sessions#omniauth_user'


  resources :users do 
    resources :events, only: [:index]
  end 

  resources :rsvps, only: [:create, :destroy]
  
  resources :producers do 
    resources :events, only: [:index]
  end 

  resources :events do 
    resources :users, only: [:index]
  end 

  resources :locations, except: [:destroy] do 
    resources :events, only: [:new, :index]
  end 
end
