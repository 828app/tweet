Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :tweets
  root  'tweets#index'
  get 'index' => 'tweets#index'
  get 'tweet' => 'tweets#tweet'
  post 'edit' => 'tweets#edit'
  post 'delete' => 'tweets#delete'
  post 'onoff' => 'tweets#onoff'
  post 'login' => 'tweets#login'
end
