Rails.application.routes.draw do

  # Docker API access
  namespace :v1 do
    resources :images, only: [:index, :create, :show, :destroy] do 
      post 'push', on: :member
    end
    
    resources :containers, only: [:index, :create, :show, :destroy]
  end

end
