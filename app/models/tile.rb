class Tile < ApplicationRecord
  validates :name, presence: true
  validates :category, presence: true
  validates :number, presence: true, inclusion: 1..9, if: :suit?

  def suit?
    category == 'suit'
  end

  def honor?
    category == 'honor'
  end

  def flower?
    category == 'flower'
  end
end
