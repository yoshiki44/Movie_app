# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Movie search and sorting', type: :system do
  before do
    driven_by(:rack_test) # JSを使うなら :selenium_chrome_headless に変更

    # 映画データを事前に用意
    Movie.create!(tmdb_id: 1, title: 'Movie A', runtime: 100, vote_average: 6.5)
    Movie.create!(tmdb_id: 2, title: 'Movie B', runtime: 110, vote_average: 8.2)
    Movie.create!(tmdb_id: 3, title: 'Movie C', runtime: 95, vote_average: 7.0)
    Movie.create!(tmdb_id: 4, title: 'Movie D', runtime: 140, vote_average: 9.0) # 検索対象外
  end

  it 'sorts movies by rating after filtering by runtime' do
    visit root_path

    fill_in 'min_runtime', with: '90'
    fill_in 'max_runtime', with: '120'
    click_button '検索'

    # 評価順リンクをクリック（selectではない！）
    click_link '評価順で並び替え'

    # 映画タイトルを取得
    movie_titles = all('.fw-bolder').map(&:text)

    expect(movie_titles).to eq(['Movie B', 'Movie C', 'Movie A'])
  end
end
