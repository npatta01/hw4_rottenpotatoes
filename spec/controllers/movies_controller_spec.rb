require 'spec_helper'

describe MoviesController do
  describe 'director exists' do
    before :each do
      @director="Person1"
      @id = "9"
      @m= Movie.new(:director=>@director,:title=>"M1")
      @m2= Movie.new(:director=>@director, :title=>"M2")
      Movie.should_receive(:find).with(@id).and_return(@m)
      Movie.should_receive(:find_similar_movies).with(@m).and_return([@m2])
    end

    it 'should query the movies model for similar movies' do
      get :similar, { :id => @id }
    end

    it 'should have results in view' do
      get :similar, { :id => @id }
      assigns(:similar_movies).should ==[@m2]
    end


  end
  describe 'no director' do


    before :each do
      @id ='9'
      @m= Movie.new(:title=>"M1")

    end

    it("should redirect to homepage is director is not listed") do
     @m.director=nil
      Movie.stub(:find).with(@id).and_return(@m)
      get :similar, {:id=>@id}
      response.should redirect_to(movies_path)
      flash[:notice].should eql("Movie '#{@m.title}' has no director info.")

    end


    it ("should redirect to homepage if director is empty string") do
      @m.director=''
      Movie.stub(:find).with(@id).and_return(@m)
      get :similar, {:id=>@id}
      response.should redirect_to(movies_path)
      flash[:notice].should eql("Movie '#{@m.title}' has no director info.")
    end

  end



end