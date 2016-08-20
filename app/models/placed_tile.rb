class PlacedTile
  attr_reader :tile, :coordinates, :x, :y, :z

  def initialize(tile, coordinates)
    @tile = tile
    @coordinates = coordinates
    @x, @y, @z = coordinates.split(',').map(&:to_i)
  end
end
