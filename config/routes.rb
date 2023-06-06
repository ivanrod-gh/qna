Rails.application.routes.draw do
  root 'questions#index'
  
  devise_for :users
  resources :users, only: %i[] do
    member do
      get :rewards
    end
  end

  resources :questions, shallow: true do
    resources :answers, shallow: true do
      member do
        post :best_mark
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
end
