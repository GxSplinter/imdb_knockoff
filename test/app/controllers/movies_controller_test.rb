require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

describe "GET /movies" do
	it "responds OK" do
		get "/movies/list"
		binding.pry
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
	it "responds OK" do
		get "/movies/new"

		assert last_response.ok?
	end
end

describe "GET /movies:id" do
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
	before do
		post "/movies", { name: "Jaws", rating: 5 }
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
