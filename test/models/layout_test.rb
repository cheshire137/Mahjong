require 'test_helper'

class LayoutTest < ActiveSupport::TestCase
  test 'requires name' do
    layout = Layout.new
    refute layout.valid?
    assert_includes layout.errors.keys, :name
  end

  test 'disallows blank tile_positions string' do
    layout = Layout.new(tile_positions: '')
    refute layout.valid?
    assert_includes layout.errors.keys, :tile_positions
  end

  test 'validates format of tile_positions' do
    layout = Layout.new(tile_positions: 'whee')
    refute layout.valid?
    assert_includes layout.errors.keys, :tile_positions
  end
end
