Rails.application.routes.draw do
  #API
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      #Post Requests
      post 'games/new', to: 'games#new'
      #Get Requests
      get 'games/history', to: 'games#index'
    end
  end
end