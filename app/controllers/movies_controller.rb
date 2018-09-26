class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @order_by = params[:order]
    @ratings = params[:ratings]
    list_of_ratings = Movie.ratings_collection
    
    if !@ratings.nil?
      selected_ratings = @ratings.keys
    else 
      selected_ratings = list_of_ratings.to_enum  
    end
    
    @all_ratings = Hash.new
    
    list_of_ratings.each do |rating|
      @all_ratings[rating] = @ratings.nil? ? true : @ratings.has_key?(rating)
      #@all_ratings[rating] = false
    end
      
    if !@order_by.nil?
      @movies = Movie.where('rating in (?)', selected_ratings).order("#{@order_by}").all
    else
      @movies = Movie.where('rating in (?)', selected_ratings)
    end  
  
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
