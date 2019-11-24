Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/customers/:id/favorite_merchant', to: 'customers/search#favorite_merchant'
      get '/customers/random', to: 'customers/search#random'
      get '/customers/find_all', to: 'customers/search#index'
      get '/customers/find', to: 'customers/search#show'
      resources :customers, only: [:index, :show] do
        resources :invoices, only: [:index], module: :customers
        resources :transactions, only: [:index], module: :customers
      end
      get '/merchants/:id/customers_with_pending_invoices', to: 'merchants/search#customers_with_pending_invoices'
      get '/merchants/:id/favorite_customer', to: 'merchants/search#favorite_customer'
      get '/merchants/revenue', to: 'merchants/search#revenue_by_date'
      get '/merchants/most_revenue', to: 'merchants/search#top_merchants'
      get '/merchants/random', to: 'merchants/search#random'
      get '/merchants/find_all', to: 'merchants/search#index'
      get '/merchants/find', to: 'merchants/search#show'
      resources :merchants, only: [:index, :show] do
        resources :invoices, only: [:index], module: :merchants
        resources :items, only: [:index], module: :merchants
      end

      get '/items/:item_id/best_day', to: 'items/search#best_day'
      get '/items/most_revenue', to: 'items/search#top_items'
      get '/items/:item_id/merchant', to: 'items/merchants#show'
      get '/items/find', to: 'items/search#show'
      get '/items/find_all', to: 'items/search#index'
      get '/items/random', to: 'items/search#random'
      resources :items, only: [:index, :show] do
        resources :invoice_items, only: [:index], module: :items
      end

      get '/invoices/:id/customer', to: 'invoices/customers#show'
      get '/invoices/:id/merchant', to: 'invoices/merchants#show'
      get '/invoices/random', to: 'invoices/search#random'
      get '/invoices/find', to: 'invoices/search#show'
      get '/invoices/find_all', to:'invoices/search#index'
      resources :invoices, only: [:index, :show] do
        resources :invoice_items, only: [:index], module: :invoices
        resources :items, only: [:index], module: :invoices
        resources :transactions, only: [:index], module: :invoices
      end

      get '/invoice_items/:id/invoice', to: 'invoice_items/invoices#show'
      get '/invoice_items/:id/item', to: 'invoice_items/items#show'
      get '/invoice_items/find', to: 'invoice_items/search#show'
      get '/invoice_items/find_all', to: 'invoice_items/search#index'
      get '/invoice_items/random', to: 'invoice_items/search#random'
      resources :invoice_items, only: [:index, :show]

      get '/transactions/:id/invoice', to: 'transactions/invoices#show'
      get '/transactions/find', to: 'transactions/search#show'
      get '/transactions/find_all', to: 'transactions/search#index'
      get '/transactions/random', to: 'transactions/search#random'
      resources :transactions, only: [:index, :show]
    end
  end
end
