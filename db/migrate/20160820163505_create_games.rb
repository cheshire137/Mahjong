class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.integer :user_id, null: false

      # tile_id:x,y,z;tile_id:x,y,z;...
      # Where x is horizontal position on the board, y is vertical position,
      # and z is depth/where the tile is stacked
      t.text :tiles, default: '', null: false

      t.integer :state, null: false, default: 0
      t.timestamps
    end
    add_index :games, :user_id
  end
end
