# frozen_string_literal: true

class AddUniqueIndexToMoviesTmdbId < ActiveRecord::Migration[6.1]
  def change
    add_index :movies, :tmdb_id, unique: true
  end
end
