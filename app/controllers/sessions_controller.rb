class SessionsController < ApplicationController
  def create
    remember_token = User.new_remember_token
    @current_user = User.find_or_create_with_omniauth(request.env['omniauth.auth'], remember_token)
    cookies.permanent[:remember_token] = remember_token
    redirect_to root_path, notice: 'ログインしました'
  end

  def destroy
    @current_user = nil
    cookies.delete(:remember_token)
    reset_session
    redirect_to root_path, notice: 'ログアウトしました'
  end

  def new
    redirect_to root_path if current_user.present?
  end
end
