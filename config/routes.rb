Rails.application.routes.draw do
  resources :silver_products do
    match '/scrape', to: 'silver_products#scrape', via: :post, on: :collection
  end

  root to: 'silver_products#index'
end
