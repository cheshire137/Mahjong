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
end
