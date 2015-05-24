require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

def session
	last_request.env['rack.session']
end

describe "GET /movies" do
	it "responds OK" do
		get "/movies/list"
		assert last_response.ok?
	end

	it "lists the saved movies" do
		movie = Movie.create!(name: 'Jaws', rating: 5)
		get "/movies/list"

		assert_includes last_response.body, movie.name
	end

	it "has a 'new movie' link" do
		get "/movies/list"

		assert_includes last_response.body, "<a href=\"new\">Add a New Movie</a>"
	end
end

describe "GET /movies/new" do
	describe "When not authenticated" do
		it "redirects to the login page" do
			get "/movies/new"

			assert last_response.redirect?
		end
	end

	describe "when authenticated" do
		it "responds OK" do
			get "/movies/new", {}, { 'rack.session' => { authenticated: true } }

			assert last_response.ok?
		end
	end
end

describe "GET /movies/:id" do
	before do
		@movie = Movie.create!(name: 'Jaws', rating: 5)

		get "/movies/#{@movie.id}"
	end

	it "displays the name" do
		assert_includes last_response.body, @movie.name
	end

	it "displays the rating" do
		assert_includes last_response.body, @movie.rating.to_s
	end
end

describe "POST /movies" do
	describe "when unauthenticated" do
		it "redirects to the login page" do
			post "/movies", { name: "Jaws", rating: 5 }

			assert last_response.redirect?, "Not redirected"
			assert_includes last_response.location, "/session/new"
		end
	end

	describe "when authenticated" do
		before do
			post "/movies",
				{ movie: { name: "Jaws", rating: 5 } },
				{ 'rack.session' => { authenticated: true } }
		end

		it "creates the movie" do
			jaws = Movie.first

			assert_equal jaws.name, "Jaws"
			assert_equal jaws.rating, 5
		end

		it "redirects to our new movie" do
			assert last_response.redirect?
		end
	end

	describe "GET /movies/:id/edit" do
		before do
			@movie = Movie.create!(name: 'Jaws', rating: 5)

			get "/movies/#{@movie.id}/edit"
		end

		it "adds the name to the edit page" do
			assert_includes last_response.body, 'value="Jaws"'
		end

		it "adds the rating to the edit page" do
			assert_includes last_response.body, 'value="5"'
		end
	end

	describe "PUT /movies/:id" do
		before do
			@movie = Movie.create!(name: 'Jaws', rating: 5)

			get "/movies/#{@movie.id}/edit"

			put "/movies/#{@movie.id}",
				{ movie: { name: "Godfather", rating: 4 } },
				{ 'rack.session' => { authenticated: true } }

				@movie.reload
		end

		it "has changed the name" do
			assert_equal @movie.name, "Godfather"
		end

		it "has changed the rating" do
			assert_equal @movie.rating, 4
		end

		it "redirects to the edited movie" do
			assert last_response.redirect?
		end
	end

	describe "DELETE /movies/:id" do
		before do
			@movie = Movie.create!(name: 'Jaws', rating: 5)

			get "/movies/#{@movie.id}/delete"

			delete "/movies/#{@movie.id}",
				{ movie: { name: "Jaws", rating: 5 } },
				{ 'rack.session' => { authenticated: true } }
		end

		it "removed the movie from the DB" do
			assert_equal Movie.count, 0
		end

		it "redirects to the list of movies" do
			assert last_response.redirect?
		end
	end
end
