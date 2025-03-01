require 'httparty'

class TmdbService
  include HTTParty
  base_uri 'https://api.themoviedb.org/3'

  API_KEY = ENV['TMDB_API'] # 環境変数にAPIキーを設定

  # 指定した上映時間の範囲で映画を検索
  def self.search_movies_by_runtime(min_runtime, max_runtime)
    response = get('/discover/movie', query: {
      api_key: API_KEY,
      with_runtime_gte: min_runtime,
      with_runtime_lte: max_runtime
    })

    if response.success?
      response.parsed_response['results'] # 映画のリストを返す
    else
      []
    end
  end

  # 映画タイトルで検索
  def self.search_movies_by_title(title)
    response = get('/search/movie', query: {
      api_key: API_KEY,
      query: title
    })

    if response.success?
      response.parsed_response['results']
    else
      []
    end
  end

  # 指定したIDの映画詳細を取得
  def self.get_movie_details(movie_id)
    response = get("/movie/#{movie_id}", query: { api_key: API_KEY })

    if response.success?
      response.parsed_response
    else
      nil
    end
  end
end
