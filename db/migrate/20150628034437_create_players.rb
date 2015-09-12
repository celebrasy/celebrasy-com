class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.belongs_to :league_template, index: true, foreign_key: true

      t.timestamps null: false
    end

    create_table :players_positions do |t|
      t.belongs_to :player, index: true, foreign_key: true
      t.belongs_to :position, index: true, foreign_key: true
    end
  end
end
