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

  describe 'destroy' do

    before :each do
      @id ="9"
      @m= Movie.new(:director=>@director,:title=>"M1", :id=>@id)
      Movie.should_receive(:find).with(@id).and_return(@m)
      #@m.stub(:destroy)
    end

    it('should delete movie') do
      @m.should_receive(:destroy)
      delete :destroy, {:id => @id}

    end


    it('should redirect to movies and show notice of movie not existing') do
      delete :destroy, {:id => @id}
      flash[:notice].should eql("Movie '#{@m.title}' deleted.")
      response.should redirect_to(movies_path)
    end



  end


  describe 'edit' do
     it ('should render edit page with same movie') do
       @id ="9"
       @m= Movie.new(:title=>"M1")
       Movie.should_receive(:find).with(@id).and_return(@m)
       get :edit, {:id=>@id}
       assigns(:movie).should equal(@m)
     end

  end



  describe 'create' do
    before :each do

      @m= Movie.new(:title=>'M1')

    end
    it ('should call Movie create') do
      Movie.should_receive(:create!).with(@m.attributes).and_return(@m)
      post :create, :movie=>@m.attributes

    end

    it ('should redirect to all movies page with notice of succesfully created') do
      post :create, :movie=>@m.attributes
      flash[:notice].should eql("#{@m.title} was successfully created.")
      response.should redirect_to(movies_path)
    end


  end


  describe 'show' do
    it ("should call Movie.find") do
      @id ="9"
      @m= Movie.new(:title=>"M1")
      Movie.should_receive(:find).with(@id).and_return(@m)
      get :show, {:id=>@id}
    end


  end


  describe 'update' do
    before :each do
      @id ="1"
      @m= Movie.new(:title=>'M1',:id=>@id)
      Movie.should_receive(:find).with(@id).and_return(@m)
    end

   # it ('should call update movie attributes') do
    #  params = {'movie'=>@m.attributes, :id=>@id}
    #  @m.should_receive(:update_attributes!)
    #  put :update, :movie=>@m.attributes, :id=>@id

    #end

    it ('should redirect to all movies page with notice of succesfully updated') do
      put :update, :movie=>@m.attributes, :id=>@id
      flash[:notice].should eql("#{@m.title} was successfully updated.")
      response.should redirect_to(movie_path)
    end


  end






end