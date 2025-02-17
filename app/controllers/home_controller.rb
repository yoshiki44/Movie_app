class HomeController < ApplicationController
  require 'net/http'
  require 'json'

  # 安全にAPIリクエストを送るメソッド
  def fetch_json(url)
    uri = URI.parse(url)
    response = Net::HTTP.get(uri)
    JSON.parse(response) rescue {}  # JSONのパースに失敗したら空のハッシュを返す
  end

  def top
    api_key = ENV['TMDB_API']
    if params[:looking_for].present?
      movie_title = params[:looking_for]
      url = "https://api.themoviedb.org/3/search/movie?api_key=#{api_key}&language=ja&query=" + URI.encode_www_form_component(movie_title)
    else
      url = "https://api.themoviedb.org/3/movie/popular?api_key=#{api_key}&language=ja"
    end

    @movies = fetch_json(url)["results"] || []  # 直接 `results` 配列を取得
  end
end
