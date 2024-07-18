Rails.application.routes.draw do

  # Docker API access
  namespace :v1 do
    resources :images, only: [:index, :create, :show, :destroy]
    #TODO: Pushing image to Dockerhub
    resources :containers, only: [:index, :create, :show, :destroy]
  end

end
