class UsersController < ApplicationController
  before_action :login_check

  def show
    @user = User.where(nickname: params[:id]).first
  end
end