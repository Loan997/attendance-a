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
  get '/time_cards/apply/:user_id/:year/:month/:day' => 'time_cards#apply'
  patch '/time_cards/approval_attendance/update' => 'time_cards#approval_attendance_update', as: 'approval_attendance_update'
  get '/time_cards/approval_attendance/:user_id/:year/:month' => 'time_cards#approval_attendance'
  patch '/time_cards/apply/update' => 'time_cards#apply_update', as: 'apply_update'
  get '/time_cards/approval_overtime_working/:user_id/:year/:month' => 'time_cards#approval_overtime_working'
  patch '/time_cards/approval_overtime_working/update' => 'time_cards#approval_overtime_working_update'
end