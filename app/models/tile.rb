class Tile < ApplicationRecord
  WIND_NAMES = %w(east south west north).freeze
  DRAGON_NAMES = %w(red green white).freeze
  CATEGORIES = %w(suit honor bonus).freeze
  FLOWER_NAMES = %w(plum orchid chrysanthemum bamboo).freeze

  validates :name, presence: true
  validates :category, presence: true, inclusion: {in: CATEGORIES}

  validates :number, presence: true, inclusion: 1..9, if: :suit_category?

  validates :set, presence: true, if: :honor_or_bonus_category?
  validates :name, inclusion: {in: WIND_NAMES}, if: :wind_tile?
  validates :name, inclusion: {in: DRAGON_NAMES}, if: :dragon_tile?
  validates :name, inclusion: {in: FLOWER_NAMES}, if: :flower_tile?

  def suit_category?
    category == 'suit'
  end

  def honor_category?
    category == 'honor'
  end

  def bonus_category?
    category == 'bonus'
  end

  def honor_or_bonus_category?
    honor_category? || bonus_category?
  end

  def wind_tile?
    honor_category? && set == 'wind'
  end

  def dragon_tile?
    honor_category? && set == 'dragon'
  end

  def flower_tile?
    bonus_category? && set == 'flower'
  end
end
