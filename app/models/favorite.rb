class Favorite < ApplicationRecord
  belongs_to :user
  validates :movie_id, presence: true, uniqueness: { scope: :user_id }
end
