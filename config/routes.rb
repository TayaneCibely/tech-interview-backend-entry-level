Rails.application.routes.draw do
  resource :cart, only: [:show, :create] do
    post :add_item
    delete 'rproduct_id', to: 'carts#remove_item', as: 'remove_item'
  end
end
