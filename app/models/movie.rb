# frozen_string_literal: true

class Movie < ApplicationRecord
  validates :title, presence: true
  validates :runtime, numericality: { only_integer: true, greater_than: 0 }

  has_many :favorites, dependent: :destroy
  has_many :favorited_by, through: :favorites
end
