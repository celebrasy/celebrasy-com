class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.belongs_to :league_template, index: true, foreign_key: true
      t.string :title
      t.integer :suggested_count

      t.timestamps null: false
    end
  end
end
