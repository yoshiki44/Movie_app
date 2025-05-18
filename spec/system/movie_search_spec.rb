# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '映画の検索機能', type: :system, js: true do
  before do
    puts "Using driver: #{Capybara.current_driver}"
    # WebMockスタブ
    stub_request(:get, /api\.themoviedb\.org/).to_return(
      status: 200,
      body: {
        genres: [
          { id: 28, name: 'アクション' },
          { id: 35, name: 'コメディ' }
        ]
      }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )

    # テスト用の映画データ
    Movie.create!(title: '短編映画', tmdb_id: 1, runtime: 40)
    Movie.create!(title: '中編映画', tmdb_id: 2, runtime: 100)
    Movie.create!(title: '長編映画', tmdb_id: 3, runtime: 180)
  end

  it '上映時間の範囲を指定して絞り込める' do
    visit '/movies'
    expect(page).to have_content('検索') # フォームが表示されたかチェック

    # 最短上映時間と最長上映時間を入力
    fill_in 'min_runtime', with: 90
    fill_in 'max_runtime', with: 120
    click_button '検索'

    # 表示される映画を確認
    expect(page).to have_content('中編映画')
    expect(page).not_to have_content('短編映画')
    expect(page).not_to have_content('長編映画')
  end
end
