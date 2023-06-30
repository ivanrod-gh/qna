Rails.application.routes.draw do
  use_doorkeeper
  root 'questions#index'
  
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  resources :users, only: %i[] do
    member do
      get :rewards
    end
  end

  resources :questions, shallow: true do
    resources :answers, shallow: true do
      member do
        post :best_mark
        post :like, defaults: { table: 'answers'}
        post :dislike, defaults: { table: 'answers'}
        post :comment, defaults: { table: 'answers'}
      end
    end

    member do
      post :like, defaults: { table: 'questions'}
      post :dislike, defaults: { table: 'questions'}
      post :comment, defaults: { table: 'questions'}
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :comments, only: :destroy

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        collection do
          get :me
          get :all_others
        end
      end
    
      resources :questions, only: %i[index show create update destroy] do
        resources :answers, shallow: true, only: %i[index show create update destroy]
      end
    end
  end

  mount ActionCable.server => '/cable'
end
