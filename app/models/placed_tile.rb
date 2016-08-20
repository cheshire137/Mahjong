class PlacedTile
  attr_reader :tile, :coordinates, :x, :y, :z, :game

  def initialize(tile, game:, coordinates:)
    @tile = tile
    @game = game
    @coordinates = coordinates
    @x, @y, @z = coordinates.split(',').map(&:to_i)
  end
end
