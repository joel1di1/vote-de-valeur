VoteDeValeur::Application.routes.draw do

  # very custom devise
  devise_for :users, :only => [] do
    post  '/users'            =>  'devise/registrations#create', :as => :user_registration
    get   '/users/sign_up'    =>  'devise/registrations#new'   , :as => :new_user_registration
    get   '/users/sign_out'   =>  'devise/sessions#destroy'    , :as => :destroy_user_session
    get   '/users/resend_instructions' => 'home#resend_instructions'
    post   '/users/resend_instructions' => 'home#do_resend_instructions'
  end

  get   'users/access/:id'  =>  'users#access', :as => 'user_access'

  get 'votes' => 'votes#index'
  get 'votes/classic' => 'votes#classic'
  post 'votes/classic' => 'votes#update_classic'
  get 'votes/explanations' => 'votes#explanations'
  post 'votes' => 'votes#update'

  root :to => "home#index"

  # juste pour les tests
  resources :configurations
  resources :candidates, :only => [:index]
  match '/test/start_mail' => 'configurations#start_mail'

end
