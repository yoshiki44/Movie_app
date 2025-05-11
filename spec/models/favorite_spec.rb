# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Favorite, type: :model do
  let(:user) { User.create(email: 'user@example.com', password: 'password') }
  let(:movie) { Movie.create(title: 'サンプル映画', runtime: 120) }

  context 'バリデーション' do
    it 'ユーザーと映画があれば有効であること' do
      favorite = Favorite.new(user: user, movie: movie)
      expect(favorite).to be_valid
    end

    it 'ユーザーがなければ無効であること' do
      favorite = Favorite.new(movie: movie)
      expect(favorite).not_to be_valid
    end

    it '映画がなければ無効であること' do
      favorite = Favorite.new(user: user)
      expect(favorite).not_to be_valid
    end

    it '同じユーザーが同じ映画を2回お気に入りできないこと' do
      Favorite.create!(user: user, movie: movie)
      duplicate = Favorite.new(user: user, movie: movie)
      expect(duplicate).not_to be_valid
    end
  end
end
