class LoginController < ApplicationController
  before_action :redirect_if_signed_in

  def index
    redirect_to temporary_games_path
  end

  private

  def redirect_if_signed_in
    if user_signed_in?
      redirect_to games_path
    end
  end
end
