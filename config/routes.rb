VoteDeValeur::Application.routes.draw do

  devise_for :users

  get 'votes' => 'votes#index'
  post 'votes' => 'votes#update'

  resources :candidates, :only => [:index]

  resources :configurations

  match '/home/to_confirmed' => "home#to_confirmed"

  root :to => "home#index"

end
