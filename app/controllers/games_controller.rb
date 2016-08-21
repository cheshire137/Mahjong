class GamesController < ApplicationController
  def index
    unless user_signed_in?
      redirect_to temporary_games_path
      return
    end
    @active_games = Game.for_user(current_user).in_progress.most_recent
    if @active_games.empty?
      active_game = Game.new(layout: Layout.first, user: current_user)
      active_game.initialize_tiles
      active_game.save!
      redirect_to active_game
      return
    elsif @active_games.size == 1
      redirect_to @active_games.first
      return
    end
    @completed_count = Game.for_user(current_user).complete.count
    @win_count = Game.for_user(current_user).won.count
    @lose_count = Game.for_user(current_user).lost.count
  end

  def temporary
    layout = if session[:layout_id]
      Layout.find(session[:layout_id])
    else
      Layout.first
    end
    @game = Game.new(layout: layout)
    session[:layout_id] = @game.layout_id
    if (tiles = session[:tiles]).present?
      @game.tiles = tiles
    else
      @game.initialize_tiles
      session[:tiles] = @game.tiles
    end
  end

  def show
    @game = current_game
  end

  def match
    game = current_game
    game.match_tiles(*params[:tiles].split(';'))
    game.save
    render partial: 'games/game_board', locals: {game: game}
  end

  def temporary_match
    game = Game.new(layout: Layout.find(params[:layout_id]),
                    tiles: params[:previous_tiles])
    game.match_tiles(*params[:tiles].split(';'))
    session[:tiles] = game.tiles
    render partial: 'games/game_board', locals: {game: game}
  end

  def shuffle
    game = current_game
    game.shuffle_tiles
    game.save
    render partial: 'games/game_board', locals: {game: game}
  end

  def temporary_shuffle
    game = Game.new(layout: Layout.find(params[:layout_id]),
                    tiles: params[:previous_tiles])
    game.shuffle_tiles
    session[:tiles] = game.tiles
    render partial: 'games/game_board', locals: {game: game}
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
