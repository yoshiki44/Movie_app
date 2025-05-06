# frozen_string_literal: true

class HomeController < ApplicationController
  require 'net/http'
  require 'json'

  def top
    api_key = ENV.fetch('TMDB_API', nil)
    base_url = 'https://api.themoviedb.org/3'
    total_pages_to_fetch = 5
    movies_per_page = 20 # 1ページあたりの映画数

    @current_page = (params[:page] || 1).to_i

    search_url = if params[:looking_for].present?
                   "#{base_url}/search/movie?api_key=#{api_key}&language=ja&query=#{URI.encode_www_form_component(params[:looking_for])}"
                 else
                   "#{base_url}/movie/popular?api_key=#{api_key}&language=ja"
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

    # トータル映画数を保存
    @total_movies = all_movies.count

    # 1ページに表示する映画を取得
    start_index = (@current_page - 1) * movies_per_page
    @movies = all_movies[start_index, movies_per_page] || []

    # トータルページ数を計算（100件を20件ずつに分ける）
    @total_pages = (@total_movies.to_f / movies_per_page).ceil
  end
end
