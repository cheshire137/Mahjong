class Layout < ApplicationRecord
  validates :tile_positions, presence: true, allow_nil: false,
                             allow_blank: false
  validate :tile_positions_state

  private

  def tile_positions_state
    return unless tile_positions
    index = tile_positions =~ /(t:\d+,\d+,\d+;?)+/
    unless index == 0
      errors.add(:tile_positions,
                 'must be in the format t:x,y,z;id:x,y,z;... with ' +
                 'numeric values')
    end
  end
end
