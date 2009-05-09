class CreateBambooTiles < ActiveRecord::Migration
  def self.up
    # http://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SchemaStatements.html#M001854
    create_table(:bamboo_tiles, :primary_key => 'rank') { |t| }
  end

  def self.down
    drop_table :bamboo_tiles
  end
end
