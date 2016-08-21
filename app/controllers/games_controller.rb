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

  def match
    @game = current_game
    @game.match_tiles(*params[:tiles].split(';'))
    respond_to do |format|
      if @game.save
        format.json {
          render json: {tiles: @game.tiles}
        }
        format.html {
          render partial: 'games/game_board', locals: {game: @game}
        }
      else
        format.json {
          render json: {errors: @game.errors.full_messages},
                 status: :unprocessable_entity
        }
        format.html {
          render partial: 'games/game_board', locals: {game: @game}
        }
      end
    end
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
