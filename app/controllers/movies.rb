ImdbKnockoff::App.controllers :movies do
  before :new, :create do
    redirect url(:session, :new) unless session[:authenticated]
  end

  get :list do
    @movies = Movie.order(:id)
    render :list
  end

  get :new do
    @movie = Movie.new
    render :new, locals: { path: url(:movies, :create) }
  end

  post :create, map: '/movies' do
    @movie = Movie.create(params[:movie])
    if @movie.valid?
      redirect url(:movies, :show, id: @movie.id)
    else
      render :new, locals: { path: url(:movies, :create) }
    end
  end

  get :show, map: '/movies/:id' do
    @movie = Movie.find(params[:id])

    render :show
  end

	get :edit, map: '/movies/:id/edit' do
		@movie = Movie.find(params[:id])
		render :new, locals: { path: url(:movies, :update, id: @movie.id) }
  end

	post :update, map: '/movies/:id' do
		@movie = Movie.find(params[:id])
		@movie.update(params[:movie])

		redirect url(:movies, :show, id: @movie.id)
	end

	post :delete, map: '/movies/:id/delete' do
		@movie = Movie.find(params[:id])
		@movie.delete(params[:movie])

		redierct url(:movies, :list)
	end
end
