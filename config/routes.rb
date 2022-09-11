Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  devise_for :users
  resources :statistics, only: [:index, :show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
