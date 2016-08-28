class Users::RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    have_layout = (layout_id = session[:layout_id]) && Layout.exists?(layout_id)
    have_tiles = (tiles = session[:tiles]).present?
    if have_layout && have_tiles
      game = Game.new(layout_id: layout_id, tiles: tiles, user: resource,
                      shuffle_count: session[:shuffle_count])
      if game.save
        session[:layout_id] = nil
        session[:tiles] = nil
        session[:shuffle_count] = nil
        return game_path(game.id)
      end
    end
    signed_in_root_path(resource)
  end
end
