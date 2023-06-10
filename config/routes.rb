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
        post :like, defaults: { votable_table: 'answers'}
        post :dislike, defaults: { votable_table: 'answers'}
      end
    end

    member do
      post :like, defaults: { votable_table: 'questions'}
      post :dislike, defaults: { votable_table: 'questions'}
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
end
