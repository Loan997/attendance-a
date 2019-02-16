Rails.application.routes.draw do


  root                'static_pages#home'
  get    'signup'  => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  get '/users/in_attendance' => 'users#in_attendance'
  get 'approval_histories/index'
  
  post 'users/import' => 'users#import'
  get '/time_cards/:user_id/:year/:month/export' => 'time_cards#export', as: 'time_cards_export'
  
  resources :users
  resources :time_basic_informations, only: [:index, :edit, :update]
  resources :time_cards
  resources :bases
  

  get '/time_cards/:user_id/:year/:month' => 'time_cards#show', as: 'attendance_show'
  
  get '/time_cards/:user_id/:year/:month/edit' => 'time_cards#edit'
  get '/time_cards/apply/:user_id/:year/:month/:day' => 'time_cards#apply'
  patch '/time_cards/approval_attendance/update' => 'time_cards#approval_attendance_update', as: 'approval_attendance_update'
  get '/time_cards/approval_attendance/:user_id/:year/:month' => 'time_cards#approval_attendance'
  patch '/time_cards/apply/update' => 'time_cards#apply_update', as: 'apply_update'
  get '/time_cards/approval_overtime_working/:user_id/:year/:month' => 'time_cards#approval_overtime_working'
  patch '/time_cards/approval_overtime_working/update' => 'time_cards#approval_overtime_working_update'
  get '/time_cards/approval_attendance_change/:user_id/:year/:month' => 'time_cards#approval_attendance_change'
  patch '/time_cards/approval_attendance_change/update' => 'time_cards#approval_attendance_change_update'
  
  get '/time_cards/confirm/:user_id/:year/:month/:month_flag' => 'time_cards#confirm', as: 'time_card_confirm'
  get '/time_cards/confirm/back/:user_id/:year/:month/:month_flag' => 'time_cards#back', as: 'time_card_back'
  
  # get '/time_cards/:user_id/:year/:month/:modal' => 'time_cards#show'
end