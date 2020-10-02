Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/movies/:id', to: 'movie#show'
  get '/movies/', to: 'movie#all'

  get '/theaters/', to: 'theater#list'
  get '/theaters/:id', to: 'theater#show'

end
