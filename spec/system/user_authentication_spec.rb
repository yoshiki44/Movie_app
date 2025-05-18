# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ユーザー認証', type: :system do
  let(:user) { FactoryBot.create(:user, password: 'password123') }

  before do
    driven_by(:rack_test)
    Movie.create!(
      tmdb_id: 1,
      title: 'テスト映画',
      overview: '概要',
      poster_path: '/dummy.jpg'
    )
  end

  describe 'ログイン機能' do
    it '① 有効なメールアドレスとパスワードでログインできる' do
      visit new_user_session_path

      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: 'password123'
      click_button 'ログイン'

      expect(page).to have_content('ログインしました')
      expect(current_path).to eq(root_path)
    end

    it '② 無効な情報でログインしたときにエラーが表示される' do
      visit new_user_session_path

      fill_in 'user[email]', with: 'invalid@example.com'
      fill_in 'user[password]', with: 'wrongpass'
      click_button 'ログイン'

      expect(page).to have_content('Eメールまたはパスワードが違います')
      expect(current_path).to eq(new_user_session_path)
    end
  end

  describe '③ ゲストログイン機能' do
    it 'ゲストログインボタンを押してトップページに遷移する' do
      visit new_user_session_path

      click_button 'ゲストログイン' # または click_link に戻しても可

      expect(page).to have_content('ゲストユーザーとしてログインしました')
      expect(current_path).to eq(root_path)
    end
  end
end
