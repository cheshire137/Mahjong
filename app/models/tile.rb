class Tile < ApplicationRecord
  WIND_NAMES = %w(east south west north).freeze
  DRAGON_NAMES = %w(red green white).freeze

  validates :name, presence: true
  validates :category, presence: true

  validates :number, presence: true, inclusion: 1..9, if: :suit_category?

  validates :set, presence: true, if: :honor_category?
  validates :name, inclusion: {in: WIND_NAMES}, if: :wind_tile?
  validates :name, inclusion: {in: DRAGON_NAMES}, if: :dragon_tile?

  def suit_category?
    category == 'suit'
  end

  def honor_category?
    category == 'honor'
  end

  def flower_category?
    category == 'flower'
  end

  def wind_tile?
    honor_category? && set == 'wind'
  end

  def dragon_tile?
    honor_category? && set == 'dragon'
  end
end
