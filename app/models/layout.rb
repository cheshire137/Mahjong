class Layout < ApplicationRecord
  validates :name, presence: true
  validates :tile_positions, presence: true
  validate :tile_positions_state

  has_many :games

  private

  def tile_positions_state
    return unless tile_positions
    index = tile_positions =~ /(\d+,\d+,\d+;?)+/
    unless index == 0
      errors.add(:tile_positions,
                 'must be in the format x,y,z;x,y,z;... with numeric values')
    end
  end
end
