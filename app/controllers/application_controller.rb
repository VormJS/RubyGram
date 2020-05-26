class ApplicationController < ActionController::Base
  protected

  def authenticate_user!
    if user_signed_in?
      super
    else
      flash[:danger] = 'You need to sign in or sign up before continuing.'
      redirect_to login_path
    end
  end
end
