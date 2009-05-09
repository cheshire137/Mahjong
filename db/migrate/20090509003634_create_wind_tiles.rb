class CreateWindTiles < ActiveRecord::Migration
  def self.up
    # Want the primary key to be a non-integer field that is not named 'id',
    # so use #execute to create the table since not using Rails convention
    execute "CREATE TABLE wind_tiles (direction enum('north', 'south', 'east', 'west') NOT NULL DEFAULT 'north', PRIMARY KEY(direction));"
  end

  def self.down
    drop_table :wind_tiles
  end
end
