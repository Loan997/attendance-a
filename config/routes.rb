Rails.application.routes.draw do

  root                'static_pages#home'
  get    'signup'  => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  resources :users
  resources :time_basic_informations, only: [:edit, :update]
  resources :time_cards
  get '/time_cards/:user_id/:year/:month' => 'time_cards#show'
  get '/time_cards/:user_id/:year/:month/edit' => 'time_cards#edit'
  
end