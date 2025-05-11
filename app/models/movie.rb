# frozen_string_literal: true

class Movie < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user

  validates :tmdb_id, presence: true, uniqueness: true
  validates :title, presence: true
  validates :runtime, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
end
