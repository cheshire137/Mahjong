class GamesController < ApplicationController
  before_action :authenticate_user!

  def index
    active_game = Game.for_user(current_user).in_progress.most_recent.first
    unless active_game
      active_game = Game.new(layout: Layout.first, user: current_user)
      active_game.initialize_tiles
      active_game.save!
    end
    redirect_to active_game
  end

  def show
    @game = current_game
  end

  def match
    @game = current_game
    @game.match_tiles(*params[:tiles].split(';'))
    @game.save
    render partial: 'games/game_board', locals: {game: @game}
  end

  private

  def current_game
    return @current_game if defined? @current_game
    game = Game.find_by_param(params[:id])
    unless game
      redirect_to games_path, alert: "That game does not exist."
      return
    end
    @current_game = game
  end
end
