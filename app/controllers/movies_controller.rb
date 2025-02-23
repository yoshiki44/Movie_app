class MoviesController < ApplicationController
  require 'net/http'
  require 'json'

  def fetch_json(url)
    response = Net::HTTP.get(URI(url))
    JSON.parse(response) rescue {}
  end

  def index
    api_key = ENV['TMDB_API']
    base_url = "https://api.themoviedb.org/3"
    total_pages_to_fetch = 5
    movies_per_page = 20  # 1ページあたりの映画数


    @current_page = (params[:page] || 1).to_i

    if params[:looking_for].present?
      search_url = "#{base_url}/search/movie?api_key=#{api_key}&language=ja&query=#{URI.encode_www_form_component(params[:looking_for])}"
    else
      search_url = "#{base_url}/movie/popular?api_key=#{api_key}&language=ja"
    end

    all_movies = []  # すべての映画を格納する配列

    # 5ページ分のデータを取得
    (1..total_pages_to_fetch).each do |page|
      url = "#{search_url}&page=#{page}"
      response = Net::HTTP.get(URI.parse(url))
      parsed_response = JSON.parse(response) rescue {}

      if parsed_response["results"].present?
        all_movies += parsed_response["results"]
      else
        break
      end
    end

      # トータル映画数を保存
      @total_movies = all_movies.count


      # 1ページに表示する映画を取得
      start_index = (@current_page - 1) * movies_per_page
      @movies = all_movies[start_index, movies_per_page] || []

      # トータルページ数を計算（100件を20件ずつに分ける）
      @total_pages = (@total_movies.to_f / movies_per_page).ceil
  end

  def show
    api_key = ENV['TMDB_API']
    movie_id = params[:id]
    url = "https://api.themoviedb.org/3/movie/#{movie_id}?api_key=#{api_key}&language=ja"
    @movie = fetch_json(url) || {}  # 取得できなかった場合は空のハッシュ
  end
end
