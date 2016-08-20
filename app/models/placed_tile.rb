class PlacedTile
  attr_reader :tile, :coordinates, :x, :y, :z, :game

  def initialize(tile, game:, coordinates:)
    @tile = tile
    @game = game
    @coordinates = coordinates
    @x, @y, @z = coordinates.split(',').map(&:to_i)
  end

  def selectable?
    return false if underneath_another?
    !left_sibling? || !right_sibling?
  end

  # 0,7 is to the left of 2,6
  def left_sibling?
    game.tile?(x - 2, y, z) || game.tile?(x - 2, y + 1, z) ||
        game.tile?(x - 2, y - 1, z)
  end

  def right_sibling?
    game.tile?(x + 2, y, z) || game.tile?(x + 2, y + 1, z) ||
        game.tile?(x + 2, y - 1, z)
  end

  # 12,8,3 is underneath 13,7,4
  # 14,8,3 is underneath 13,7,4
  # 12,6,3 is underneath 13,7,4
  # 14,6,3 is underneath 13,7,4
  def underneath_another?
    game.tile?(x, y, z + 1) || game.tile?(x + 1, y - 1, z + 1) ||
        game.tile?(x - 1, y - 1, z + 1) || game.tile?(x + 1, y + 1, z + 1) ||
        game.tile?(x - 1, y + 1, z + 1)
  end
end
