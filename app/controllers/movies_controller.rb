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
    
    key = params[:id]
    
    @all_ratings = Movie.pluck(:rating).uniq
    
    if(params[:ratings])
      @checked_ratings=params[:ratings].keys
      session[:ratings]=@checked_ratings
    else 
      if @checked_ratings.nil? 
        @checked_rating = @all_ratings 
      else
      @checked_ratings = session[:ratings]
      end
    end
    
    if(key)
       session[:key] = key 
    else
      key = session[:key]
    end
   
      
    
    @checked_ratings.each do |rating|
      params[rating] = true
    end

    if key == 'title_header'
      @title_header = 'hilite'
      @movies = Movie.where(:rating=>@checked_ratings ).order('LOWER(title)')
      
     # @movies = Movie.order('LOWER(title)')
    elsif key== 'release_date_header'
      @release_date_header = 'hilite'
      @movies = Movie.where(:rating=>@checked_ratings).order(:release_date)
     # @movies = Movie.order(:release_date)
    else
      @movies = Movie.where(:rating=>@checked_ratings)
      
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
