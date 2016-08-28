class AddShuffleCountToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :shuffle_count, :integer, null: false, default: 0
  end
end
