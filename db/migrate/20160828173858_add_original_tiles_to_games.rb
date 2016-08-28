class AddOriginalTilesToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :original_tiles, :text, null: false, default: ''
  end
end
