class ApplicationController < ActionController::Base
  before_action :current_user

  private
  def current_user
    return nil unless cookies[:remember_token]
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def login_check
    redirect_to login_path unless current_user.present?
  end
end
