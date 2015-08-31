class CreateLeaguePositions < ActiveRecord::Migration
  def change
    create_table :league_positions do |t|
      t.belongs_to :league, index: true, foreign_key: true
      t.belongs_to :position, index: true, foreign_key: true
      t.string :title
      t.integer :count

      t.timestamps null: false
    end
  end
end
