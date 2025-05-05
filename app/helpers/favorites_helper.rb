# frozen_string_literal: true

module FavoritesHelper
  require 'net/http'
  require 'json'

  TMDB_API_KEY = ENV.fetch('TMDB_API', nil) # APIキーを設定

  def get_movie_from_api(movie_id)
    url = URI("https://api.themoviedb.org/3/movie/#{movie_id}?api_key=#{TMDB_API_KEY}&language=ja")
    response = Net::HTTP.get(url)
    begin
      JSON.parse(response)
    rescue StandardError
      nil
    end
  end
end
