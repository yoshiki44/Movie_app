# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe 'バリデーション' do
    it '有効な映画情報であれば有効であること' do
      movie = Movie.new(title: 'テスト映画', runtime: 120)
      expect(movie).to be_valid
    end

    it 'タイトルがないと無効であること' do
      movie = Movie.new(runtime: 120)
      movie.valid?
      expect(movie.errors[:title]).to include('を入力してください')
    end

    it '上映時間が数値でないと無効であること' do
      movie = Movie.new(title: 'テスト', runtime: 'abc')
      movie.valid?
      expect(movie.errors[:runtime]).to include('は数値で入力してください')
    end

    it '上映時間が0以下だと無効であること' do
      movie = Movie.new(title: 'テスト', runtime: 0)
      movie.valid?
      expect(movie.errors[:runtime]).to include('は0より大きい値にしてください')
    end
  end
end
