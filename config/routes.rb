Rails.application.routes.draw do
 
  devise_for :users
 root to: 'home#index'

  get 'home/index'

  get 'about' => 'pages#about'
  get 'terms' => 'pages#terms'
  resources :articles do
    resources :comments, only: [:create]
  end
  resource :contacts, only: [:create, :new], path_names: {:new => ''}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
