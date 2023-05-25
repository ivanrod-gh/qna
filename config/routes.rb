Rails.application.routes.draw do
  root 'questions#index'
  
  devise_for :users

  resources :questions, shallow: true do
    resources :answers, shallow: true do
      member do
        post :best_mark
      end
    end
  end
end
