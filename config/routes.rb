VoteDeValeur::Application.routes.draw do

  devise_for :users, :skip => [:sessions] do
    get 'users/sign_out' => 'devise/sessions#destroy', :as => :destroy_user_session
  end
  get 'users/access/:id' => 'users#access', :as => 'user_access'

  get 'votes' => 'votes#index'
  post 'votes' => 'votes#update'

  resources :candidates, :only => [:index]


  resources :configurations

  match '/home/to_confirmed' => "home#to_confirmed"

  root :to => "home#index"

end
