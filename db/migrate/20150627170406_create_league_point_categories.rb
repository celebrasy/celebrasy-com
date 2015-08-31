class CreateLeaguePointCategories < ActiveRecord::Migration
  def change
    create_table :league_point_categories do |t|
      t.belongs_to :league, index: true, foreign_key: true
      t.belongs_to :point_category, index: true, foreign_key: true
      t.string :group
      t.string :title
      t.decimal :value

      t.timestamps null: false
    end
  end
end
