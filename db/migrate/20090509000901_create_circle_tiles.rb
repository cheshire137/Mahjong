class CreateCircleTiles < ActiveRecord::Migration
  def self.up
    # http://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SchemaStatements.html#M001854
    create_table(:circle_tiles, :primary_key => 'rank') { |t| }
  end

  def self.down
    drop_table :circle_tiles
  end
end
