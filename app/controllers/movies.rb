ImdbKnockoff::App.controllers :movies do
  get :new do
    render :new
  end

  post :create, map: '/movies' do
    movie = Movie.create!(name: params['name'], rating: params['rating'])

    redirect url(:movies, :show, id: movie.id)
  end

  get :show, map: 'movies/:id' do
    @movie = Movie.find(params[:id])
    
    render :show
  end
end
