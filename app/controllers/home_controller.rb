class HomeController < ApplicationController
  before_action :login_check

  def index
    @users_of_received = @current_user.users_of_received_claps_from.limit(40)
  end
end
