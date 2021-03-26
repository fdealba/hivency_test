Rails.application.routes.draw do
  #API
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      #Post Requests
      post 'new', to: 'games#new'
      #Get Requests
      get 'index', to: 'games#index'
    end
  end
end