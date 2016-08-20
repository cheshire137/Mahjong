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

  test 'requires valid category' do
    tile = Tile.new(category: 'whatever')
    refute tile.valid?
    assert_includes tile.errors.keys, :category
  end

  test 'wind_tile? is true when category is honor and set is wind' do
    tile = Tile.new(category: 'honor', set: 'wind')
    assert tile.wind_tile?
  end

  test 'wind_tile? is false when category is not honor' do
    tile = Tile.new(category: 'flower', set: 'wind')
    refute tile.wind_tile?
  end

  test 'wind_tile? is false when set is not wind' do
    tile = Tile.new(category: 'honor', set: 'dragon')
    refute tile.wind_tile?
  end

  test 'dragon_tile? is true when category is honor and set is dragon' do
    tile = Tile.new(category: 'honor', set: 'dragon')
    assert tile.dragon_tile?
  end

  test 'dragon_tile? is false when category is not honor' do
    tile = Tile.new(category: 'flower', set: 'dragon')
    refute tile.dragon_tile?
  end

  test 'dragon_tile? is false when set is not dragon' do
    tile = Tile.new(category: 'honor', set: 'wind')
    refute tile.dragon_tile?
  end

  test 'validates set if honor category' do
    tile = Tile.new(category: 'honor', set: 'heynow')
    refute tile.valid?
    assert_includes tile.errors.keys, :set
  end

  test 'validates set if bonus category' do
    tile = Tile.new(category: 'bonus', set: 'heynow')
    refute tile.valid?
    assert_includes tile.errors.keys, :set
  end

  test 'requires set if honor category' do
    tile = Tile.new(category: 'honor')
    refute tile.valid?
    assert_includes tile.errors.keys, :set
  end

  test 'requires set if bonus category' do
    tile = Tile.new(category: 'bonus')
    refute tile.valid?
    assert_includes tile.errors.keys, :set
  end

  test 'requires suit if suit category' do
    tile = Tile.new(category: 'suit')
    refute tile.valid?
    assert_includes tile.errors.keys, :suit
  end

  test 'validates suit if suit category' do
    tile = Tile.new(category: 'suit', suit: 'fun')
    refute tile.valid?
    assert_includes tile.errors.keys, :suit
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

  test 'bonus_category? is true when category is bonus' do
    assert Tile.new(category: 'bonus').bonus_category?
  end

  test 'suit_category? is false when category is not suit' do
    refute Tile.new(category: 'honor').suit_category?
  end

  test 'honor_category? is false when category is not honor' do
    refute Tile.new(category: 'bonus').honor_category?
  end

  test 'bonus_category? is false when category is not bonus' do
    refute Tile.new(category: 'suit').bonus_category?
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

  test 'validates name for flower tiles' do
    tile = Tile.new(name: 'whee', category: 'bonus', set: 'flower')
    refute tile.valid?
    assert_includes tile.errors.keys, :name
  end
end
