VoteDeValeur::Application.routes.draw do

  # very custom devise
  devise_for :users, :only => [] do
    post  '/users'                     =>  'devise/registrations#create', :as => :user_registration
    get   '/users/sign_up'             =>  'devise/registrations#new'   , :as => :new_user_registration
    get   '/users/sign_out'            =>  'devise/sessions#destroy'    , :as => :destroy_user_session
    get   '/users/resend_instructions' => 'home#resend_instructions'
    post  '/users/resend_instructions' => 'home#do_resend_instructions'
  end

  resources :users, :only => [] do
    collection do 
      get 'count'
    end
  end
  constraints :id => /[^\/]+/ do
    get 'users/opening_email'
    post 'users/send_opening_email' => 'users#send_opening_email'
  end

  get 'users/access/:id'  =>  'users#access', :as => 'user_access'

  resources :votes, :only => [:index, :create] do
    collection do
      get 'explanations'
    end
  end

  get 'feedbacks' => 'feedbacks#new'
  post 'feedbacks' => 'feedbacks#create'

  get 'thanks' => 'home#thanks'

  root :to => "home#index"

  # juste pour les tests
  resources :candidates, :only => [:index]
  match '/test/start_mail' => 'configurations#start_mail'

end
