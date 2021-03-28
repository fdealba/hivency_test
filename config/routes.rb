Rails.application.routes.draw do
  #API
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      #Post Requests
      post 'play', to: 'games#new'
      #Get Requests
      get 'games_history', to: 'games#index'
    end
  end
end