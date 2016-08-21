require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test 'requires a user' do
    game = Game.new
    refute game.valid?
    assert_includes game.errors.keys, :user
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
    game = create(:game)
    count = 0
    game.each_tile do |placed_tile|
      count += 1
    end
    assert_equal 144, count
  end

  test "tile? returns true when given coordinates are occupied" do
    game = create(:game)
    assert game.tile?(2, 14, 0)
    assert game.tile?(12, 4, 2)
    assert game.tile?(18, 6, 1)

    refute game.tile?(3, 1, 1)
    refute game.tile?(0, 7, 1)
  end

  test 'populates tiles on create' do
    game = build(:game)
    assert game.tiles.blank?
    assert game.save
    refute game.tiles.blank?
  end

  test 'does not change tiles on update' do
    game = create(:game)
    before_value = game.reload.tiles
    game.updated_at = 1.day.ago
    assert game.save
    assert_equal before_value, game.reload.tiles
  end

  test 'max coordinates from all tiles' do
    game = create(:game)

    assert_equal 28, game.max_x
    assert_equal 14, game.max_y
    assert_equal 4, game.max_z
  end
end
