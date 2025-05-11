# frozen_string_literal: true

class AddGenreIdsToMovies < ActiveRecord::Migration[6.1]
  def change
    add_column :movies, :genre_ids, :string
  end
end
