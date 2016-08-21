class Game < ApplicationRecord
  TILES_REGEX = /(\d+:\d+,\d+,\d+;?)+/
  STATES = {:in_progress => 0, :won => 1, :lost => 2}.freeze

  belongs_to :user
  belongs_to :layout

  validates :user, presence: true
  validates :layout, presence: true
  validates :tiles, presence: true, allow_nil: false, allow_blank: true
  validate :tile_state

  scope :in_progress, ->{ where(state: STATES[:in_progress]) }
  scope :won, ->{ where(state: STATES[:in_progress]) }
  scope :lost, ->{ where(state: STATES[:lost]) }
  scope :complete, ->{ where.not(state: STATES[:in_progress]) }
  scope :for_user, ->(user) { where(user: user) }
  scope :most_recent, ->{ order("updated_at DESC") }

  def state
    STATES.key(self[:state])
  end

  def state=(state)
    self[:state] = STATES[state.to_sym]
  end

  def to_param
    "#{id}:#{created_at.to_i}"
  end

  def self.find_by_param(param)
    id, created_at = param.split(':')
    find(id)
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def initialize_tiles
    return unless layout
    tiles = Tile.all
    return if tiles.empty?
    tile_counts = Hash.new(0)
    tile_positions = []
    layout.each_position do |coordinates|
      tile = tiles.sample
      while tile_counts[tile.id] == Tile::MAX_PER_GAME
        tile = tiles.sample
      end
      tile_counts[tile.id] += 1
      tile_positions << "#{tile.id}:#{coordinates}"
    end
    self.tiles = tile_positions.join(';')
  end

  def tile_count
    tiles.split(';').size
  end

  def max_x
    find_max_coordinates unless defined? @max_x
    @max_x
  end

  def max_y
    find_max_coordinates unless defined? @max_y
    @max_y
  end

  def max_z
    find_max_coordinates unless defined? @max_z
    @max_z
  end

  def row_count
    (max_y / 2.0) + 1
  end

  def column_count
    (max_x / 2.0) + 1
  end

  def each_tile
    unless defined? @placed_tiles
      positions = tiles.split(';')
      coordinates_and_tiles = {}
      positions.each do |tile_and_coordinates|
        tile_id, coordinates = tile_and_coordinates.split(':')
        tile_id = tile_id.to_i
        coordinates_and_tiles[coordinates] = tile_id
      end
      tiles_by_id = Tile.where(id: coordinates_and_tiles.values.uniq).
                         map { |t| [t.id, t] }.to_h
      @placed_tiles = coordinates_and_tiles.map do |coordinates, tile_id|
        PlacedTile.new(tiles_by_id[tile_id], coordinates: coordinates,
                       game: self)
      end
    end
    @placed_tiles.each do |placed_tile|
      yield placed_tile
    end
  end

  def tile?(x, y, z)
    index = tiles =~ /\d+:#{x},#{y},#{z}/
    !index.nil?
  end

  def match_tiles(tile1, tile2)
    return false if tile1 == tile2 # can't match a tile with itself
    new_positions = tiles.split(';').
        reject { |position| position == tile1 || position == tile2 }
    self.tiles = new_positions.join(';')
    true
  end

  private

  def find_max_coordinates
    @max_x = -1
    @max_y = -1
    @max_z = -1
    each_tile do |placed_tile|
      @max_x = placed_tile.x if placed_tile.x > @max_x
      @max_y = placed_tile.y if placed_tile.y > @max_y
      @max_z = placed_tile.z if placed_tile.z > @max_z
    end
  end

  def tile_state
    return unless tiles.present?
    index = tiles =~ TILES_REGEX
    unless index == 0
      errors.add(:tiles, 'must be in the format id:x,y,z;id:x,y,z;... with ' +
                         'numeric values')
    end
  end
end
