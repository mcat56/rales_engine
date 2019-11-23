Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/customers/random', to: 'customers#random'
      get '/customers/find_all', to: 'customers#find_all'
      get '/customers/find', to: 'customers#find'
      get '/customers/:id/favorite_merchant', to: 'customers#favorite_merchant'
      resources :customers, only: [:index, :show] do
        resources :invoices, only: [:index], module: :customers
        resources :transactions, only: [:index], module: :customers
      end
      get '/merchants/:id/favorite_customer', to: 'merchants#favorite_customer'
      get '/merchants/revenue', to: 'merchants#revenue_by_date'
      get '/merchants/most_revenue', to: 'merchants#top_merchants'
      get '/merchants/random', to: 'merchants#random'
      get '/merchants/find_all', to: 'merchants#find_all'
      get '/merchants/find', to: 'merchants#find'
      resources :merchants, only: [:index, :show] do
        resources :invoices, only: [:index], module: :merchants
        resources :items, only: [:index], module: :merchants
      end
      get '/items/:item_id/best_day', to: 'items#best_day'
      get '/items/most_revenue', to: 'items#top_items'
      get '/items/:item_id/merchant', to: 'items/merchants#show'
      get '/items/find', to: 'items#find'
      get '/items/find_all', to: 'items#find_all'
      get '/items/random', to: 'items#random'
      resources :items, only: [:index, :show] do
        resources :invoice_items, only: [:index], module: :items
      end
      get '/invoices/random', to: 'invoices#random'
      get '/invoices/find', to: 'invoices#find'
      get '/invoices/find_all', to:'invoices#find_all'
      resources :invoices, only: [:index, :show] do
        resources :invoice_items, only: [:index], module: :invoices
        resources :items, only: [:index], module: :invoices
        resources :transactions, only: [:index], module: :invoices
      end
    end
  end
end
