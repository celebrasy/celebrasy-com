class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :first_name
      t.string :last_name
      t.belongs_to :league_template, index: true, foreign_key: true
      t.belongs_to :position, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
