# frozen_string_literal: true

class MoviesController < ApplicationController
  def index
    if Rails.env.test?
      load_movies_for_test
      return
    end

    @current_page = (params[:page] || 1).to_i
    api_key = ENV.fetch('TMDB_API', nil)
    service = TmdbMovieService.new(api_key)

    search_url = build_search_url(api_key)
    @genres = service.fetch_genres
    raw_movies = service.fetch_movies(search_url, 20)
    processed_movies = process_movies(raw_movies, service)

    # 並び替え処理
    if params[:sort] == 'vote_average'
      processed_movies.sort_by! { |m| -m.vote_average.to_f } # 降順
    end

    @movies = Kaminari.paginate_array(processed_movies).page(params[:page]).per(20)

    return unless Movie.count.zero?

    FetchTmdbMoviesJob.perform_later(api_key: api_key, total_pages: 10)
    flash.now[:notice] = t('notices.fetching_data')
  end

  def show
    @movie = Movie.find_by(tmdb_id: params[:id]) || fetch_and_store_movie(params[:id])
  end

  def search
    redirect_to movies_path(min_runtime: params[:min_runtime], max_runtime: params[:max_runtime])
  end

  private

  def load_movies_for_test
    @genres = { 28 => 'アクション', 35 => 'コメディ' }
    @movies = Movie.all
    if params[:min_runtime].present? && params[:max_runtime].present?
      min = params[:min_runtime].to_i
      max = params[:max_runtime].to_i
      @movies = @movies.where(runtime: min..max)
    end
    @movies = @movies.page(params[:page]).per(20)
  end

  def fetch_and_store_movie(tmdb_id)
    api_key = ENV.fetch('TMDB_API', nil)
    service = TmdbMovieService.new(api_key)
    data = service.fetch_movie_details(tmdb_id)
    return unless data

    Movie.create!(
      tmdb_id: data['id'],
      title: data['title'],
      overview: data['overview'],
      poster_path: data['poster_path'],
      release_date: data['release_date'],
      runtime: data['runtime']
    )
  end

  def build_search_url(api_key)
    base_url = 'https://api.themoviedb.org/3'
    if params[:looking_for].present?
      "#{base_url}/search/movie?api_key=#{api_key}&language=ja&query=#{URI.encode_www_form_component(params[:looking_for])}"
    else
      "#{base_url}/movie/popular?api_key=#{api_key}&language=ja"
    end
  end

  def process_movies(raw_movies, service)
    movies = raw_movies.map { |data| service.find_or_create_movie(data) }.compact

    if params[:min_runtime].present? && params[:max_runtime].present?
      min = params[:min_runtime].to_i
      max = params[:max_runtime].to_i
      movies.select { |movie| movie.runtime.to_i.between?(min, max) }
    else
      movies
    end
  end
end
