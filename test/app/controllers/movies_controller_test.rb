require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

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
