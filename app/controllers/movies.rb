ImdbKnockoff::App.controllers :movies do 
  post :index do
    movie = Movie.create!(name: params['name'], rating: params['rating'])

    redirect url(:movies, :show, id: movie.id)
  end

  get :show, map: 'movies/:id' do 
    "TODO!"
  end
end
