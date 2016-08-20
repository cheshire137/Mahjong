module GamesHelper
  def tile_class(tile)
    css = "mahjong-tile category-#{tile.category}"
    if tile.honor_or_bonus_category?
      css << " name-#{tile.name} set-#{tile.set}"
    elsif tile.suit_category?
      css << " suit-#{tile.suit} number-#{tile.number}"
    end
    css
  end

  def tile_style(placed_tile, max_x, max_y)
    relative_x = (placed_tile.x.to_f / max_x) * 100
    x_position = "left: #{relative_x}%"

    relative_y = (placed_tile.y.to_f / max_y) * 100
    y_position = "top: #{relative_y}%"

    z_position = "z-index: #{placed_tile.z}"
    [x_position, y_position, z_position].join('; ')
  end
end
