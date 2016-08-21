module GamesHelper
  def tile_class(placed_tile, file)
    tile = placed_tile.tile
    css = "mahjong-tile category-#{tile.category}"
    if tile.honor_or_bonus_category?
      css << " name-#{tile.name} set-#{tile.set}"
    elsif tile.suit_category?
      css << " suit-#{tile.suit} number-#{tile.number}"
    end
    if placed_tile.directly_underneath?
      css << " is-directly-underneath"
    else
      css << " is-visible"
    end
    if placed_tile.selectable?
      css << " selectable"
    elsif placed_tile.underneath_another?
      css << " is-underneath"
    end
    if file
      css << " has-image"
    else
      css << " no-image"
    end
    css
  end

  # 37w x 46h = 0.804 aspect ratio
  def tile_style(placed_tile)
    game = placed_tile.game

    relative_x = ((placed_tile.x - game.min_x).to_f / (game.max_x + 3)) * 100
    relative_y = ((placed_tile.y - game.min_y).to_f / (game.max_y + 3)) * 100

    x_position = "left: #{relative_x}%"
    y_position = "top: #{relative_y}%"
    z_position = "z-index: #{placed_tile.z}"
    [x_position, y_position, z_position].join('; ')
  end

  def tile_tag(placed_tile)
    match_url = if user_signed_in?
      match_game_path(placed_tile.game)
    else
      temporary_match_games_path(layout_id: placed_tile.game.layout_id)
    end
    if placed_tile.selectable?
      tile = placed_tile.tile
      %Q(a href="#" data-tile-id="#{tile.id}" data-set="#{tile.set}" data-suit="#{tile.suit}" data-category="#{tile.category}" data-number="#{tile.number}" data-name="#{tile.name}" data-match-url="#{match_url}")
    else
      'div'
    end.html_safe
  end
end
