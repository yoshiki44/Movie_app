class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  def guest_user?
   email == "guest@example.com"
  end

  has_many :favorites, dependent: :destroy
  has_many :favorite_movies, through: :favorites, source: :movie_id
end
