# frozen_string_literal: true

class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  validates :user_id
  validates :movie_id, uniqueness: { scope: :user_id }
end
