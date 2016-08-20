class AddLayoutIdToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :layout_id, :integer, null: false
    add_index :games, :layout_id
  end
end
