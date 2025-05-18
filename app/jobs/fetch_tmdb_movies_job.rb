# frozen_string_literal: true

class FetchTmdbMoviesJob < ApplicationJob
  queue_as :default

  def perform(api_key:, total_pages:)
    service = TmdbMovieService.new(api_key)
    url = service.build_search_url
    movies = service.fetch_movies(url, total_pages)

    movies.each do |movie_data|
      service.find_or_create_movie(movie_data) # ← 修正された呼び出し
    end
  end
end
