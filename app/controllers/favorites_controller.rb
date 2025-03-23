class FavoritesController < ApplicationController
  before_action :authenticate_user!  # Deviseなどを使用している場合
  helper FavoritesHelper

  def index
    @favorites = current_user.favorites
  end

  def create
    favorite = current_user.favorites.create(movie_id: params[:movie_id])
    redirect_back fallback_location: root_path, notice: "お気に入りに追加しました！"
  end

  def destroy
    favorite = current_user.favorites.find(params[:id]) # id で検索
    favorite.destroy
    redirect_back fallback_location: favorites_path, notice: "お気に入りを解除しました。"
  end
end
