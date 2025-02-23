class FavoritesController < ApplicationController
  before_action :authenticate_user!  # Deviseなどを使用している場合

  def create
    favorite = current_user.favorites.create(movie_id: params[:movie_id])
    redirect_back fallback_location: root_path, notice: "お気に入りに追加しました！"
  end

  def destroy
    favorite = current_user.favorites.find_by(movie_id: params[:movie_id])
    favorite.destroy if favorite
    redirect_back fallback_location: root_path, notice: "お気に入りを解除しました。"
  end
end
