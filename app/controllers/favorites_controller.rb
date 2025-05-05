# frozen_string_literal: true

class FavoritesController < ApplicationController
  before_action :authenticate_user! # Deviseなどを使用している場合
  helper FavoritesHelper

  def index
    @favorites = current_user.favorites
  end

  def create
    current_user.favorites.create(movie_id: params[:movie_id])
    redirect_back fallback_location: root_path, notice: t('notices.add_to_favorites')
  end

  def destroy
    favorite = current_user.favorites.find(params[:id]) # id で検索
    favorite.destroy
    redirect_back fallback_location: favorites_path, notice: t('notices.remove_from_favorites')
  end
end
