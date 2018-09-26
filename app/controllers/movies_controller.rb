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
    # When a fresh window opens, we face a unique situaltion.
    # 1. Our order by is not set.
    # 2. Our checkbox selection is not saved.
    # so first we should detect that whether any of these are set or not.
    # if any or both of these are not set but the corresponding session variables are set then we use session hash to restore the value
    if(params[:order_by].nil? && params[:ratings].nil? && (!session[:order_by].nil? || !session[:ratings].nil?))
      flash.keep
      redirect_to movies_path(:order_by => session[:order_by], :ratings => session[:ratings])
    end  
    
    @order_by = params[:order]
    @ratings = params[:ratings]
    # Get a collection of ratings from the database
    list_of_ratings = Movie.ratings_collection
    
    if !@ratings.nil?
      selected_ratings = @ratings.keys
    else
      # select everything if all the checkboxes are unselected
      selected_ratings = list_of_ratings.to_enum  
    end
    
    # create a hash which would be used in haml file.
    @all_ratings = Hash.new
    
    list_of_ratings.each do |rating|
      @all_ratings[rating] = @ratings.nil? ? true : @ratings.has_key?(rating)
    end
      
    if !@order_by.nil?
      @movies = Movie.where('rating in (?)', selected_ratings).order("#{@order_by}").all
    else
      @movies = Movie.where('rating in (?)', selected_ratings)
    end  
    # we need to preserve the "order by" settings and the "checkbox" settings
    session[:order_by] = @order_by
    session[:ratings] = @ratings
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
