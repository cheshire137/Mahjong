module GamesHelper
  def tile_class(placed_tile)
    tile = placed_tile.tile
    css = "mahjong-tile category-#{tile.category}"
    if tile.honor_or_bonus_category?
      css << " name-#{tile.name} set-#{tile.set}"
    elsif tile.suit_category?
      css << " suit-#{tile.suit} number-#{tile.number}"
    end
    if placed_tile.selectable?
      css << " selectable"
    end
    css
  end

  def tile_style(placed_tile)
    game = placed_tile.game

    relative_x = (placed_tile.x.to_f / (game.max_x + 3)) * 100
    x_position = "left: #{relative_x}%"

    relative_y = (placed_tile.y.to_f / (game.max_y + 3)) * 100
    y_position = "top: #{relative_y}%"

    z_position = "z-index: #{placed_tile.z}"

    relative_width = (100.0 / game.column_count) * 0.94
    width = "width: #{relative_width}vw"

    relative_height = (100.0 / game.row_count) * 0.94
    height = "height: #{relative_height}vh"

    [x_position, y_position, z_position, width, height].join('; ')
  end
end
