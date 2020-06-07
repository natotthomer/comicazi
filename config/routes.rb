Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :books
  post 'books/batch_create', to: 'book#batch_create', as: :batch_create
end
