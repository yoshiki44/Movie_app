# frozen_string_literal: true

class MoviesController < ApplicationController
  require 'net/http'
  require 'json'

  def fetch_json(url)
    response = Net::HTTP.get(URI(url))
    begin
      JSON.parse(response)
    rescue StandardError
      {}
    end
  end

  def index
    api_key = ENV.fetch('TMDB_API', nil)
    base_url = 'https://api.themoviedb.org/3'
    total_pages_to_fetch = 20 # 1ページあたりの映画数

    @current_page = (params[:page] || 1).to_i

    if params[:looking_for].present?
      search_url = "#{base_url}/search/movie?api_key=#{api_key}&language=ja&query=#{URI.encode_www_form_component(params[:looking_for])}"
    else
      search_url = "#{base_url}/movie/popular?api_key=#{api_key}&language=ja"
    end

    all_movies = [] # すべての映画を格納する配列

    # 5ページ分のデータを取得
    (1..total_pages_to_fetch).each do |page|
      url = "#{search_url}&page=#{page}"
      response = Net::HTTP.get(URI.parse(url))
      parsed_response = begin
        JSON.parse(response)
      rescue StandardError
        {}
      end

      break if parsed_response['results'].blank?

      all_movies += parsed_response['results']
    end

    filtered_movies = []

    if params[:min_runtime].present? && params[:max_runtime].present?
      min_runtime = params[:min_runtime].to_i
      max_runtime = params[:max_runtime].to_i

      all_movies.each do |movie|
        details_url = "#{base_url}/movie/#{movie['id']}?api_key=#{api_key}&language=ja"
        details = fetch_json(details_url)

        # `details` が nil でないことを確認
        next unless details && details['runtime']

        runtime = details['runtime'].to_i

        # 指定範囲の映画のみ追加
        filtered_movies << movie if runtime.between?(min_runtime, max_runtime)
      end
    else
      filtered_movies = all_movies
    end

    genres_url = "#{base_url}/genre/movie/list?api_key=#{api_key}&language=ja"
    genre_response = fetch_json(genres_url)
    @genres = genre_response['genres'].to_h { |g| [g['id'], g['name']] }

    # `filtered_movies` が `nil` の場合は `[]` にする
    filtered_movies ||= []

    # `kaminari` でページネーション
    @movies = Kaminari.paginate_array(filtered_movies).page(params[:page]).per(20)
  end

  def show
    api_key = ENV.fetch('TMDB_API', nil)
    movie_id = params[:id]
    url = "https://api.themoviedb.org/3/movie/#{movie_id}?api_key=#{api_key}&language=ja"
    @movie = fetch_json(url) || {} # 取得できなかった場合は空のハッシュ
  end

  def search
    redirect_to movies_path(min_runtime: params[:min_runtime], max_runtime: params[:max_runtime])
  end
end
