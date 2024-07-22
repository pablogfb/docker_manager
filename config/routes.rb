Rails.application.routes.draw do
  # Docker API access
  namespace :v1 do
    resources :images, only: %i[index create show destroy] do
      member do
        post "push"
        post "tag"
      end
      post "from_file", on: :collection
    end

    resources :containers, only: %i[index create show destroy] do
      member do
        post "action"
        get "logs"
      end
    end
  end
end
