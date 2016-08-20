class CreateLayouts < ActiveRecord::Migration[5.0]
  def change
    create_table :layouts do |t|
      t.string :name, null: false

      # t:x,y,z;t:x,y,z;...
      # Where t represents any tile, x is horizontal position on the board, y
      # is vertical position, and z is depth/where the tile is stacked
      t.text :tile_positions, null: false
    end
  end
end
