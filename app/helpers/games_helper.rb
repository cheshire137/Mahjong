module GamesHelper
  def tile_class(placed_tile, file)
    tile = placed_tile.tile
    css = "mahjong-tile category-#{tile.category}"
    if tile.honor_or_bonus_category?
      css << " name-#{tile.name} set-#{tile.set}"
    elsif tile.suit_category?
      css << " suit-#{tile.suit} number-#{tile.number}"
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

  def tile_tag(placed_tile)
    if placed_tile.selectable?
      tile = placed_tile.tile
      %Q(a href="#" data-tile-id="#{tile.id}" data-coords="#{placed_tile.coordinates}" data-set="#{tile.set}" data-suit="#{tile.suit}" data-category="#{tile.category}" data-number="#{tile.number}" data-name="#{tile.name}")
    else
      'div'
    end.html_safe
  end
end
