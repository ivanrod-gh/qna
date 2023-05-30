Rails.application.routes.draw do
  root 'questions#index'
  
  devise_for :users

  resources :questions, shallow: true do
    resources :answers, shallow: true do
      member do
        post :best_mark
      end
    end

    # member do
    #   post :destroy_attached_file
    # end
  end

  # post '/attachments/:id', to: 'attachments#destroy'
  # post '/questions/:id/destroy_attached_file/:attachment_id', to: 'questions#destroy_attached_file'
  delete '/attachments/:id', to: 'attachments#destroy', as: 'attachment'
end


# get '/patients/:id', to: 'patients#show'
