class Game < ApplicationRecord
  STATES = {:in_progress => 0, :won => 1, :lost => 2}.freeze

  belongs_to :user
  belongs_to :layout

  before_save :initialize_tiles, on: :create

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
  end

  def initialize_tiles
    return unless layout
    tiles = Tile.all
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

  def each_tile
    unless defined? @placed_tiles
      positions = tiles.split(';')
      tiles_and_coordinates = {}
      positions.each do |tile_and_coordinates|
        tile_id, coordinates = tile_and_coordinates.split(':')
        tile_id = tile_id.to_i
        tiles_and_coordinates[tile_id] = coordinates
      end
      tiles_by_id = Tile.where(id: tiles_and_coordinates.keys).
                         map { |t| [t.id, t] }.to_h
      @placed_tiles = tiles_and_coordinates.map do |tile_id, coordinates|
        PlacedTile.new(tiles_by_id[tile_id], coordinates)
      end
    end
    @placed_tiles.each do |placed_tile|
      yield placed_tile
    end
  end

  private

  def tile_state
    return unless tiles.present?
    index = tiles =~ /(\d+:\d+,\d+,\d+;?)+/
    unless index == 0
      errors.add(:tiles, 'must be in the format id:x,y,z;id:x,y,z;... with ' +
                         'numeric values')
    end
  end
end
