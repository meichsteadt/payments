Rails.application.routes.draw do
  root to: "users#show"
  devise_for :users, controllers: { registrations: "registrations" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :charges
  resources :users
  resources :subscriptions
  devise_scope :user do
    get '/sign_up', to: 'devise/registrations#new'
    get '/sign_in', to: 'devise/sessions#new'
  end
end
