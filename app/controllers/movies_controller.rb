class MoviesController < ApplicationController
  def index
    if params[:looking_for]
      movie_title = params[:looking_for]
      url = "https://api.themoviedb.org/3/search/movie?api_key=#{ENV['5cce7d24821ed6d91e21d7a998c605a5']}&language=ja&query=" + URI.encode_www_form_component(movie_title)
    else
      url = "https://api.themoviedb.org/3/movie/popular?api_key=#{ENV['5cce7d24821ed6d91e21d7a998c605a5']}&language=ja"
    end
    @movies = JSON.parse(Net::HTTP.get(URI.parse(url)))
  end

  def show
    movie_id = params[:id]
    url = "https://api.themoviedb.org/3/movie/#{movie_id}?api_key=#{ENV['5cce7d24821ed6d91e21d7a998c605a5']}&language=ja"
    @movie = JSON.parse(Net::HTTP.get(URI.parse(url)))
  end
end
