class ClapsController < ApplicationController
  before_action :login_check

  def create
    user = User.find(params[:user_id])
    @current_user.clap(user)
    @current_user.tweet(params[:text]) if params[:text].present?
    redirect_to user_path(user), notice: "#{user.name} さんに ぱちぱち しました!"
  end
end