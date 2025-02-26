class Users::SessionsController < Devise::SessionsController
  before_action :check_guest_user, only: [:update]

  def check_guest_user
    if current_user&.guest_user?
      sign_out current_user
      redirect_to root_path, alert: "ゲストユーザーのため変更できません。"
    end
  end

  def guest_login
    user = User.find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
    end
    sign_in user
    redirect_to root_path, notice: "ゲストユーザーとしてログインしました。"
  end

  def destroy
    if current_user.email == 'guest@example.com'
      sign_out current_user
      redirect_to root_path, notice: 'ゲストユーザーはログアウトしました。'
    else
      super
    end
  end
end
