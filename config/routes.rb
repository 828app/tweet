Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :tweets
  get 'tweet' => 'tweets#tweet'
  # post '' => 'topics#comment'

end
