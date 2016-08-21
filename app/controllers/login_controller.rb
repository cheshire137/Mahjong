class LoginController < ApplicationController
  def index
    if user_signed_in?
      redirect_to games_path
    else
      redirect_to temporary_games_path
    end
  end
end
