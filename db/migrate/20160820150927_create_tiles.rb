class CreateTiles < ActiveRecord::Migration[5.0]
  def change
    create_table :tiles do |t|
      t.string :category, :null => false # e.g., suit, honor, bonus
      t.string :name # e.g., east, red, north, plum, summer
      t.integer :number # 1-9
      t.string :suit # e.g., circle, bamboo, character
      t.string :set # e.g., wind, dragon, flower, season
    end
  end
end
