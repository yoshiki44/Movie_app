# frozen_string_literal: true

class AddIndexToFavoritesMovieIdAndUserId < ActiveRecord::Migration[6.1]
  def change
    add_index :favorites, %i[movie_id user_id], unique: true
  end
end
