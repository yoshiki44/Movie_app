# frozen_string_literal: true

class Movie < ApplicationRecord
  validates :title, presence: true
  validates :runtime, numericality: { only_integer: true, greater_than: 0 }
end
