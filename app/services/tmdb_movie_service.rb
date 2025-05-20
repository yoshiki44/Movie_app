# frozen_string_literal: true

class TmdbMovieService
  def initialize(api_key, base_url = 'https://api.themoviedb.org/3')
    @api_key = api_key
    @base_url = base_url
  end

  def fetch_movies(search_url, total_pages)
    all_movies = []

    (1..total_pages).each do |page|
      url = "#{search_url}&page=#{page}"
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

  def fetch_genres
    url = "#{@base_url}/genre/movie/list?api_key=#{@api_key}&language=ja"
    response = fetch_json(url)
    response['genres'].to_h { |g| [g['id'].to_i, g['name']] }
  end

  def find_or_create_movie(data)
    movie = Movie.find_or_initialize_by(tmdb_id: data['id'])

    return movie if movie.persisted? && movie.runtime.present?

    details = fetch_movie_details(data['id'])
    return nil unless details

    movie.update(
      title: data['title'],
      overview: data['overview'],
      poster_path: data['poster_path'],
      release_date: data['release_date'],
      runtime: details['runtime'],
      genre_ids: data['genre_ids']&.join(','),
      vote_average: data['vote_average']
    )
    sleep 0.1
    movie
  end

  def fetch_movie_details(movie_id)
    url = "#{@base_url}/movie/#{movie_id}?api_key=#{@api_key}&language=ja"
    fetch_json(url)
  end

  def fetch_and_store_movie(tmdb_id)
    data = fetch_movie_details(tmdb_id)
    return unless data

    Movie.create!(
      tmdb_id: data['id'],
      title: data['title'],
      overview: data['overview'],
      poster_path: data['poster_path'],
      release_date: data['release_date'],
      runtime: data['runtime'],
      vote_average: data['vote_average']
    )
  end

  def build_search_url(query = nil)
    if query.present?
      "#{@base_url}/search/movie?api_key=#{@api_key}&language=ja&query=#{URI.encode_www_form_component(query)}"
    else
      "#{@base_url}/movie/popular?api_key=#{@api_key}&language=ja"
    end
  end

  private

  def fetch_json(url)
    response = Net::HTTP.get(URI.parse(url))
    JSON.parse(response)
  rescue StandardError
    nil
  end
end
