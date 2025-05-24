# frozen_string_literal: true

class AddVoteAverageToMovies < ActiveRecord::Migration[6.1]
  def change
    add_column :movies, :vote_average, :float
  end
end
