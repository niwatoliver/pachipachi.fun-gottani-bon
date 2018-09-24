Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root   'home#index'
  get    '/auth/:provider/callback' => 'sessions#create'
  post   '/claps'                   => 'claps#create'         , as: :clap
  get    '/logout'                  => 'sessions#destroy'     , as: :logout
  get    '/login'                   => 'sessions#new'         , as: :login
  post   '/subscription'            => 'subscriptions#create'
  get    '/users/:id'               => 'users#show'           , as: :user
end
