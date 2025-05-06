# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :check_guest_user, only: %i[edit update]

    def edit; end

    def update; end

    private

    def check_guest_user
      Rails.logger.debug '>>> check_guest_user called'
      return unless current_user&.guest_user?

      redirect_to root_path, alert: t('notices.guest_change')
    end
  end
end
