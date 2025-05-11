# frozen_string_literal: true

class AddTitleAndRuntimeToMovies < ActiveRecord::Migration[6.1]
  def change
    add_column :movies, :title, :string
    add_column :movies, :runtime, :integer
  end
end
