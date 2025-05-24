# frozen_string_literal: true

class MovieProcessingService
  def initialize(movies, params)
    @movies = movies
    @params = params
  end

  def filter_by_runtime
    return @movies unless @params[:min_runtime].present? && @params[:max_runtime].present?

    min = @params[:min_runtime].to_i
    max = @params[:max_runtime].to_i
    @movies.select { |movie| movie.runtime.to_i.between?(min, max) }
  end

  def sort
    case @params[:sort]
    when 'vote_average'
      @movies.sort_by { |movie| -(movie.vote_average || 0) }
    when 'release_date'
      @movies.sort_by do |movie|
        date = begin
          Date.parse(movie.release_date)
        rescue StandardError
          Date.new(1900)
        end
        -date.to_time.to_i
      end
    else
      @movies
    end
  end
end
