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

  mount ActionCable.server => '/cable'
end
