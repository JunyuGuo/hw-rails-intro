class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @all_ratings = Movie.get_all_ratings
      list = params[:sort_by]
      
      f_ratings = params[:ratings]
      #puts(f_ratings)
      if f_ratings != nil
      #  @movies = Movie.with_ratings(f_ratings)
      #  return
        session[:f_ratings] = f_ratings
      end
      
      if list != nil
        session[:list] = list
      end

      if list == nil and f_ratings == nil and (session[:f_ratings] != nil or session[:list] != nil)
        f_ratings = session[:f_ratings]
        list = session[:list]
        flash.keep
        redirect_to movies_path({sort_by: list, ratings: f_ratings})
      end
      list = session[:list]
      f_ratings = session[:f_ratings]
      
      if list == nil 
        @movies = Movie.all()
      else
        @movies = Movie.all().order(list)
        if list == 'title'
          @title = 'bg-warning'
        elsif list == 'release_date'
          @date = 'bg-warning'
        end 
      end
      if f_ratings != nil
        @movies = @movies.select{ |movie| f_ratings.include? movie.rating}
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
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end