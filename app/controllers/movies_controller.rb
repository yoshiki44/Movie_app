# frozen_string_literal: true

class MoviesController < ApplicationController
  require 'net/http'
  require 'json'

  def index
    api_key = ENV.fetch('TMDB_API', nil)
    base_url = 'https://api.themoviedb.org/3'
    total_pages_to_fetch = 20

    @current_page = (params[:page] || 1).to_i

    search_url = build_search_url(base_url, api_key)
    all_movies = fetch_movies(search_url, total_pages_to_fetch)

    filtered_movies = if params[:min_runtime].present? && params[:max_runtime].present?
                        filter_movies_by_runtime(all_movies, base_url, api_key)
                      else
                        all_movies
                      end

    @genres = fetch_genres(base_url, api_key)
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

  private

  def build_search_url(base_url, api_key)
    if params[:looking_for].present?
      "#{base_url}/search/movie?api_key=#{api_key}&language=ja&query=#{URI.encode_www_form_component(params[:looking_for])}"
    else
      "#{base_url}/movie/popular?api_key=#{api_key}&language=ja"
    end
  end

  def fetch_movies(base_url, total_pages)
    all_movies = []

    (1..total_pages).each do |page|
      url = "#{base_url}&page=#{page}"
      response = Net::HTTP.get(URI.parse(url))
      parsed = begin
        JSON.parse(response)
      rescue StandardError
        {}
      end

      break if parsed['results'].blank?

      all_movies += parsed['results']
    end

    all_movies
  end

  def filter_movies_by_runtime(movies, base_url, api_key)
    min_runtime = params[:min_runtime].to_i
    max_runtime = params[:max_runtime].to_i

    movies.select do |movie|
      details_url = "#{base_url}/movie/#{movie['id']}?api_key=#{api_key}&language=ja"
      details = fetch_json(details_url)

      details && details['runtime'].to_i.between?(min_runtime, max_runtime)
    end
  end

  def fetch_genres(base_url, api_key)
    url = "#{base_url}/genre/movie/list?api_key=#{api_key}&language=ja"
    response = fetch_json(url)
    response['genres'].to_h { |g| [g['id'], g['name']] }
  end

  def fetch_json(url)
    response = Net::HTTP.get(URI.parse(url))
    begin
      JSON.parse(response)
    rescue StandardError
      nil
    end
  end
end
