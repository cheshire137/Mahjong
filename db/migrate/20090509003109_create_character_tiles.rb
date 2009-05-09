class CreateCharacterTiles < ActiveRecord::Migration
  def self.up
    # http://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SchemaStatements.html#M001854
    create_table(:character_tiles, :primary_key => 'rank') { |t| }
  end

  def self.down
    drop_table :character_tiles
  end
end
