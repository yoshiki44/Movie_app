# frozen_string_literal: true

class FavoritesController < ApplicationController
  before_action :authenticate_user!
  helper FavoritesHelper

  def index
    @favorites = current_user.favorites
  end

  def create
    movie = Movie.find_by(tmdb_id: params[:movie_id])

    if movie
      current_user.favorites.create(movie_id: movie.id)
      redirect_back fallback_location: root_path, notice: t('notices.add_to_favorites')
    else
      redirect_back fallback_location: root_path, alert: t('alerts.movie_not_found')
    end
  end

  def destroy
    favorite = current_user.favorites.find_by(id: params[:id])
    if favorite
      favorite.destroy
      redirect_back fallback_location: favorites_path, notice: t('notices.removed_from_favorites')
    else
      redirect_back fallback_location: favorites_path, alert: t('alerts.favorite_not_found')
    end
  end
end
