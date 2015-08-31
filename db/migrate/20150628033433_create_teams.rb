class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.belongs_to :league, index: true, foreign_key: true
      t.string :title

      t.timestamps null: false
    end
  end
end
