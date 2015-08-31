class CreateLeaguePlayers < ActiveRecord::Migration
  def change
    create_table :league_players do |t|
      t.string :first_name
      t.string :last_name
      t.belongs_to :league, index: true, foreign_key: true
      t.belongs_to :league_position, index: true, foreign_key: true
      t.belongs_to :player, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
