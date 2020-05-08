class ApplicationController < ActionController::Base

  private

    # Confirms a logged-in user.
    def logged_in_user
      unless user_signed_in?
        store_location
        flash[:danger] = 'Please log in.'
        redirect_to login_url
      end
    end
end
