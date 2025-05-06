class Users::RegistrationsController < ApplicationController

  module Users
    class RegistrationsController < Devise::RegistrationsController
      before_action :check_guest_user, only: [:update]

      private

      def check_guest_user
        if current_user&.guest_user?
          redirect_to root_path, alert: t('notices.guest_change')
        end
      end
    end
  end

end
