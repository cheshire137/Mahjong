require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test 'requires a user' do
    game = Game.new
    refute game.valid?
    assert_includes game.errors.keys, :user
  end

  test 'defaults to 0 shuffle count' do
    assert_equal 0, Game.new.shuffle_count
  end

  test 'requires >=0 shuffle count' do
    game = Game.new(shuffle_count: -1)
    refute game.valid?
    assert_includes game.errors.keys, :shuffle_count
  end

  test 'allows blank tiles string' do
    game = Game.new(tiles: '')
    game.valid?
    refute_includes game.errors.keys, :tiles
  end

  test 'validates format of tiles' do
    game = Game.new(tiles: 'whee')
    refute game.valid?
    assert_includes game.errors.keys, :tiles
  end

  test 'validates numericality of tile IDs' do
    game = Game.new(tiles: 'a:1,2,3')
    refute game.valid?
    assert_includes game.errors.keys, :tiles
  end

  test "state translates 0 to :in_progress" do
    game = Game.new
    game[:state] = 0
    assert_equal :in_progress, game.state
  end

  test "state translates 1 to :won" do
    game = Game.new
    game[:state] = 1
    assert_equal :won, game.state
  end

  test "state translates 2 to :lost" do
    game = Game.new
    game[:state] = 2
    assert_equal :lost, game.state
  end

  test "state= sets state to in_progress from :in_progress" do
    game = build(:game)
    game.state = :in_progress
    game.save!
    assert_equal :in_progress, game.reload.state
  end

  test "state= sets state to in_progress from 'in_progress'" do
    game = build(:game)
    game.state = "in_progress"
    game.save!
    assert_equal :in_progress, game.reload.state
  end

  test "state= sets state to lost from :lost" do
    game = build(:game)
    game.state = :lost
    game.save!
    assert_equal :lost, game.reload.state
  end

  test "state= sets state to lost from 'lost'" do
    game = build(:game)
    game.state = "lost"
    game.save!
    assert_equal :lost, game.reload.state
  end

  test "state= sets state to won from :won" do
    game = build(:game)
    game.state = :won
    game.save!
    assert_equal :won, game.reload.state
  end

  test "state= sets state to won from 'won'" do
    game = build(:game)
    game.state = "won"
    game.save!
    assert_equal :won, game.reload.state
  end

  test 'each_tile loops over each tile in tiles' do
    game = build(:game)
    game.initialize_tiles
    game.save!

    count = 0
    game.each_tile do |placed_tile|
      count += 1
    end
    assert_equal 144, count
  end

  test "tile? returns true when given coordinates are occupied" do
    game = build(:game)
    game.initialize_tiles
    game.save!

    assert game.tile?(2, 14, 0)
    assert game.tile?(12, 4, 2)
    assert game.tile?(18, 6, 1)

    refute game.tile?(3, 1, 1)
    refute game.tile?(0, 7, 1)
  end

  test 'initialize_tiles populates tiles and original_tiles' do
    game = build(:game)
    assert game.tiles.blank?

    game.initialize_tiles
    refute game.tiles.blank?
    assert_equal game.tiles, game.original_tiles
  end

  test 'does not change tiles or original_tiles on update' do
    game = build(:game)
    game.initialize_tiles
    game.save!

    before_value = game.reload.tiles
    game.updated_at = 1.day.ago
    assert game.save
    assert_equal before_value, game.reload.tiles
    assert_equal before_value, game.original_tiles
  end

  test 'max coordinates from all tiles' do
    game = build(:game)
    game.initialize_tiles
    game.save!

    assert_equal 28, game.max_x
    assert_equal 14, game.max_y
    assert_equal 4, game.max_z
  end

  test 'match_tiles will not match a tile with itself' do
    game = build(:game)
    game.initialize_tiles
    tile = game.tiles.split(';').first

    refute game.match_tiles(tile, tile)
    assert game.tiles.include?(tile)
  end

  test 'match_tiles marks game as won when last pair is removed' do
    game = build(:game)
    tile_id = Tile.first.id
    game.tiles = "#{tile_id}:0,2,0;#{tile_id}:0,4,0"

    assert_equal :in_progress, game.state
    game.match_tiles("#{tile_id}:0,2,0", "#{tile_id}:0,4,0")

    assert_equal :won, game.state
    assert game.tiles.blank?
  end

  test 'match_tiles removes a valid match from tiles list' do
    game = build(:game)
    game.initialize_tiles
    tiles = game.tiles.split(';')
    tile1 = tiles.first
    tile1_id = tile1.split(':').first
    tile2 = tiles.detect { |t| t != tile1 && t.split(':').first == tile1_id }

    assert game.match_tiles(tile1, tile2)
    refute game.tiles.include?(tile1)
    refute game.tiles.include?(tile2)
    assert_equal :in_progress, game.state
  end

  test 'match_tiles will not remove an invalid match from tiles list' do
    game = build(:game)
    game.initialize_tiles
    tiles = game.tiles.split(';')
    tile1 = tiles.first
    tile1_id = tile1.split(':').first.to_i
    tiles_by_id = Tile.all.map { |t| [t.id, t] }.to_h
    tile1_obj = tiles_by_id[tile1_id]
    tile2 = tiles.detect do |t|
      t_id = t.split(':').first.to_i
      t_obj = tiles_by_id[t_id]
      t != tile1 && !tile1_obj.match?(t_obj)
    end

    refute game.match_tiles(tile1, tile2)
    assert game.tiles.include?(tile1)
    assert game.tiles.include?(tile2)
    assert_equal :in_progress, game.state
  end

  test 'has_shuffles_remaining? returns true when not at limit' do
    assert Game.new.has_shuffles_remaining?
    assert Game.new(shuffle_count: Game::MAX_SHUFFLES - 1).
        has_shuffles_remaining?
  end

  test 'has_shuffles_remaining? returns false when at limit' do
    refute Game.new(shuffle_count: Game::MAX_SHUFFLES).has_shuffles_remaining?
  end

  test 'shuffles_remaining returns count of shuffles left in game' do
    assert_equal Game::MAX_SHUFFLES, Game.new.shuffles_remaining
    assert_equal 1, Game.new(shuffle_count: Game::MAX_SHUFFLES - 1).
        shuffles_remaining
  end

  test 'shuffle_tiles reorders tiles' do
    game = build(:game)
    game.initialize_tiles
    before_tiles = game.tiles

    tiles_before = {}
    game.each_tile do |placed_tile|
      tiles_before[placed_tile.tile.id] ||= []
      tiles_before[placed_tile.tile.id] << placed_tile.coordinates
    end
    tiles_before.each do |id, coords_list|
      tiles_before[id] = coords_list.sort
    end

    assert_equal 0, game.shuffle_count

    game.shuffle_tiles
    refute game.tiles.blank?
    assert game.valid?
    refute_equal before_tiles, game.tiles
    assert_equal before_tiles, game.original_tiles
    assert_equal 1, game.shuffle_count

    tiles_after = {}
    game.each_tile do |placed_tile|
      tiles_after[placed_tile.tile.id] ||= []
      tiles_after[placed_tile.tile.id] << placed_tile.coordinates
    end
    tiles_after.each do |id, coords_list|
      tiles_after[id] = coords_list.sort
      refute_equal tiles_before[id], tiles_after[id]
    end
  end

  test 'reset starts the game over again' do
    game = build(:game)
    game.initialize_tiles
    before_tiles = game.tiles

    game.shuffle_tiles
    game.shuffle_tiles

    assert_equal 2, game.shuffle_count
    refute_equal before_tiles, game.tiles
    assert_equal :in_progress, game.state

    game.reset

    assert_equal 0, game.shuffle_count
    assert_equal before_tiles, game.tiles
    assert_equal :in_progress, game.state
  end
end
