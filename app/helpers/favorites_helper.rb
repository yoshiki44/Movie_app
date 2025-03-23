module FavoritesHelper
  require 'net/http'
  require 'json'

  TMDB_API_KEY = ENV["TMDB_API"] # APIキーを設定

  def get_movie_from_api(movie_id)
    url = URI("https://api.themoviedb.org/3/movie/#{movie_id}?api_key=#{TMDB_API_KEY}&language=ja")
    response = Net::HTTP.get(url)
    JSON.parse(response) rescue nil
  end
end
