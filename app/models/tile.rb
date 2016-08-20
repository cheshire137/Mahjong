class Tile < ApplicationRecord
  MAX_PER_GAME = 4
  CATEGORIES = %w(suit honor bonus).freeze
  SETS = %w(wind dragon flower season).freeze
  SUITS = %w(circle bamboo character).freeze
  WIND_NAMES = %w(east south west north).freeze
  DRAGON_NAMES = %w(red green white).freeze
  FLOWER_NAMES = %w(plum orchid chrysanthemum bamboo).freeze
  SEASON_NAMES = %w(spring summer autumn winter).freeze

  validates :category, presence: true, inclusion: {in: CATEGORIES}
  validates :number, presence: true, inclusion: 1..9, if: :suit_category?
  validates :suit, presence: true, inclusion: {in: SUITS}, if: :suit_category?
  validates :set, presence: true, inclusion: {in: SETS},
                  if: :honor_or_bonus_category?
  validates :name, presence: true, if: :honor_or_bonus_category?
  validates :name, inclusion: {in: WIND_NAMES}, if: :wind_tile?
  validates :name, inclusion: {in: DRAGON_NAMES}, if: :dragon_tile?
  validates :name, inclusion: {in: FLOWER_NAMES}, if: :flower_tile?
  validates :name, inclusion: {in: SEASON_NAMES}, if: :season_tile?

  def circle_suit?
    suit == 'circle'
  end

  def bamboo_suit?
    suit == 'bamboo'
  end

  def character_suit?
    suit == 'character'
  end

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

  def season_tile?
    bonus_category? && set == 'season'
  end

  def to_s
    str = "#{category}"
    if honor_or_bonus_category?
      str << ": #{name} #{set}"
    elsif suit_category?
      str << ": #{suit} #{number}"
    end
    str
  end
end
