# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController

    def check_guest_user
      return unless current_user&.guest_user?

      sign_out current_user
      redirect_to root_path, alert: t('notices.guest_change')
    end

    def guest_login
      user = User.find_or_create_by!(email: 'guest@example.com') do |user|
        user.password = SecureRandom.urlsafe_base64
        user.name = 'ゲストユーザー'
      end
      sign_in user
      redirect_to root_path, notice: t('notices.guest_login')
    end

    def destroy
      if current_user.email == 'guest@example.com'
        sign_out current_user
        redirect_to root_path, notice: t('notices.guest_logout')
      else
        super
      end
    end
  end
end
