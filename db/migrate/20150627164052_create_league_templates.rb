class CreateLeagueTemplates < ActiveRecord::Migration
  def change
    create_table :league_templates do |t|
      t.string :title

      t.timestamps null: false
    end
  end
end
