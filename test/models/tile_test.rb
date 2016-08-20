require 'test_helper'

class TileTest < ActiveSupport::TestCase
  test 'requires name' do
    tile = Tile.new
    refute tile.valid?
    assert_includes tile.errors.keys, :name
  end

  test 'requires category' do
    tile = Tile.new
    refute tile.valid?
    assert_includes tile.errors.keys, :category
  end

  test 'requires set if honor category' do
    tile = Tile.new(category: 'honor')
    refute tile.valid?
    assert_includes tile.errors.keys, :set
  end

  test 'requires number if suit category' do
    tile = Tile.new(category: 'suit')
    refute tile.valid?
    assert_includes tile.errors.keys, :number
  end

  test 'requires number >= 1' do
    tile = Tile.new(category: 'suit', number: 0)
    refute tile.valid?
    assert_includes tile.errors.keys, :number
  end

  test 'requires number <= 9' do
    tile = Tile.new(category: 'suit', number: 10)
    refute tile.valid?
    assert_includes tile.errors.keys, :number
  end

  test 'suit_category? is true when category is suit' do
    assert Tile.new(category: 'suit').suit_category?
  end

  test 'honor_category? is true when category is honor' do
    assert Tile.new(category: 'honor').honor_category?
  end

  test 'flower_category? is true when category is flower' do
    assert Tile.new(category: 'flower').flower_category?
  end

  test 'validates name for wind tiles' do
    tile = Tile.new(name: 'whee', category: 'honor', set: 'wind')
    refute tile.valid?
    assert_includes tile.errors.keys, :name
  end

  test 'validates name for dragon tiles' do
    tile = Tile.new(name: 'whee', category: 'honor', set: 'dragon')
    refute tile.valid?
    assert_includes tile.errors.keys, :name
  end
end
