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
end
