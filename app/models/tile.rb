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

  def image_file
    name = image_name
    return unless name.present?
    "#{name}.svg"
  end

  def image_name
    if honor_or_bonus_category?
      if dragon_tile?
        "drag#{name}"
      elsif flower_tile?
        "flower#{FLOWER_NAMES.index(name) + 1}"
      elsif wind_tile?
        "wind#{name}"
      elsif season_tile?
        "season#{SEASON_NAMES.index(name) + 1}"
      end
    elsif suit_category?
      "#{suit[0..3]}#{number}"
    end
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

  # Keep in sync with games.js isMatch
  def match?(other_tile)
    return false unless category == other_tile.category
    if suit_category?
      return false unless suit == other_tile.suit
      return false unless number == other_tile.number
    end
    return false unless set == other_tile.set
    if %w(wind dragon).include? set
      return false unless name == other_tile.name
    end
    true
  end

  def self.create_all_tiles
    SUITS.each do |suit|
      (1..9).each do |number|
        create!(number: number, suit: suit, category: 'suit')
      end
    end

    WIND_NAMES.each do |name|
      create!(name: name, set: 'wind', category: 'honor')
    end

    DRAGON_NAMES.each do |name|
      create!(name: name, set: 'dragon', category: 'honor')
    end

    FLOWER_NAMES.each do |name|
      create!(name: name, set: 'flower', category: 'bonus')
    end

    SEASON_NAMES.each do |name|
      create!(name: name, set: 'season', category: 'bonus')
    end
  end
end
