class CreatePointCategories < ActiveRecord::Migration
  def change
    create_table :point_categories do |t|
      t.belongs_to :league_template, index: true, foreign_key: true
      t.string :group
      t.string :title
      t.decimal :suggested_value

      t.timestamps null: false
    end
  end
end
