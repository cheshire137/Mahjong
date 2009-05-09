class CreateDragonTiles < ActiveRecord::Migration
  def self.up
    # Want the primary key to be a non-integer field that is not named 'id',
    # so use #execute to create the table since not using Rails convention
    execute "CREATE TABLE dragon_tiles (color enum('red', 'green', 'white') NOT NULL DEFAULT 'red', PRIMARY KEY(color));"
  end

  def self.down
    drop_table :dragon_tiles
  end
end
