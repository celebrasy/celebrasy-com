class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.string :title
      t.belongs_to :league_template, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
