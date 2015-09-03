class CreatePointSubmissions < ActiveRecord::Migration
  def change
    create_table :point_submissions do |t|
      t.belongs_to :league, index: true, foreign_key: true
      t.belongs_to :team, index: true, foreign_key: true
      t.belongs_to :league_player, index: true, foreign_key: true
      t.belongs_to :league_point_category, index: true, foreign_key: true
      t.decimal :points
      t.integer :status, default: 0
      t.string :proof_url

      t.timestamps null: false
    end
  end
end
