class HomeController < ApplicationController
  require 'net/http'
  require 'json'

  def index
    api_key = ENV['TMDB_API']
    base_url = "https://api.themoviedb.org/3"
    total_pages_to_fetch = 3

    @current_page = (params[:page] || 1).to_i

    if params[:looking_for].present?
      search_url = "#{base_url}/search/movie?api_key=#{api_key}&language=ja&query=#{URI.encode_www_form_component(params[:looking_for])}"
    else
      search_url = "#{base_url}/movie/popular?api_key=#{api_key}&language=ja"
    end

    @movies = []

    (1..total_pages_to_fetch).each do |page|
      url = "#{search_url}&page=#{page}"
      puts "Fetching URL: #{url}"  # 確認用ログ

      response = Net::HTTP.get(URI.parse(url))
      parsed_response = JSON.parse(response) rescue {}

      if parsed_response["results"].present?
        @movies += parsed_response["results"]
      else
        break
      end

      # `total_pages` の値を正しく更新
      @total_pages = parsed_response["total_pages"] if @total_pages.nil? || parsed_response["total_pages"] > @total_pages

      puts "Fetched #{@movies.count} movies so far."
      puts "Total available pages: #{@total_pages}"
    end
  end
end
