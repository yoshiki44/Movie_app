require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    it "有効な情報ならユーザーは有効である" do
      user = User.new(email: "test@example.com", password: "password")
      expect(user).to be_valid
    end

    it "メールアドレスがないと無効である" do
      user = User.new(password: "password")
      user.valid?
      expect(user.errors[:email]).to include("を入力してください")
    end

    it "パスワードがないと無効である" do
      user = User.new(email: "test@example.com")
      user.valid?
      expect(user.errors[:password]).to include("を入力してください")
    end

    it "同じメールアドレスは登録できない" do
      User.create!(email: "duplicate@example.com", password: "password")
      user = User.new(email: "duplicate@example.com", password: "password")
      user.valid?
      expect(user.errors[:email]).to include("はすでに存在します")
    end

    it "パスワードが6文字未満だと無効である" do
      user = User.new(email: "test@example.com", password: "123")
      user.valid?
      expect(user.errors[:password]).to include("は6文字以上で入力してください")
    end
  end
end
