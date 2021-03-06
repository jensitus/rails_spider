Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/movies/:id', to: 'movie#single_movie'
  get '/movies/', to: 'movie#all'

  get '/theaters/', to: 'theater#list'
  get '/theaters/:id', to: 'theater#show'
  get '/theaters/:id/schedules', to: 'theater#theater_schedules'
  get '/theaters/:id/schedules/movies', to: 'theater#the_movies'

end
