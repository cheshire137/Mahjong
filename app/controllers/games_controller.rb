class GamesController < ApplicationController
  before_action :authenticate_user!

  def index
    active_game = Game.for_user(current_user).in_progress.most_recent.first
    unless active_game
      active_game = Game.new
      active_game.layout = Layout.first
      active_game.user = current_user
      active_game.save!
    end
    redirect_to active_game
  end

  def show
    @game = current_game
  end

  private

  def current_game
    return @current_game if defined? @current_game
    @current_game = Game.find_by_param(params[:id])
  end
end
