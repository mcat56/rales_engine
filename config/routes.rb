Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/customers/random', to: 'customers#random'
      get '/customers/find_all', to: 'customers#find_all'
      get '/customers/find', to: 'customers#find'
      resources :customers, only: [:index, :show]

    end
  end
end
