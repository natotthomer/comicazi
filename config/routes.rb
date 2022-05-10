Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :books
  namespace :admin do
    resources :books do
      collection do
        get :batch_new
        post :batch_create
        get :batch_show
      end
    end
  end
  namespace :api do
    resources :books
  end
end
