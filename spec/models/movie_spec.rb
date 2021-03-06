require 'spec_helper'

describe Movie do

  it 'should should find similar movies with same director' do
    director="Person1"
    m= Movie.new(:director=>director,:title=>"M1")
    m2= Movie.new(:director=>director, :title=>"M2")
    Movie.stub(:find_all_by_director).with(director).and_return([m2])

    similar_movies= Movie.find_similar_movies(m)
    similar_movies.first.should ==m2
    similar_movies.count.should==1

  end

  it ('should return expected movie ratings') do
    expected =%w(G PG PG-13 NC-17 R)
    actual = Movie.all_ratings

    actual.should match_array expected
  end

end