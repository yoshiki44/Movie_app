# frozen_string_literal: true

class AddTmdbFieldsToMovies < ActiveRecord::Migration[6.1]
  def change
    add_column :movies, :tmdb_id, :integer
    add_column :movies, :overview, :text
    add_column :movies, :poster_path, :string
    add_column :movies, :release_date, :date
    add_column :movies, :genre_ids, :string
  end
end
