require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe Movie do
  it "can construct a new instance" do
    movie = Movie.new
    refute_nil movie
  end
end
