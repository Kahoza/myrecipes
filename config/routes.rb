Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'pages#home'
  get 'pages/home', to: 'pages#home'

  resources :recipes

  get '/signup', to: 'chefs#new'
  resources :chefs, except: [:new]
end
