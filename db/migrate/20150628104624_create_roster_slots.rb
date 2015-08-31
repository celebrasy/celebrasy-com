class CreateRosterSlots < ActiveRecord::Migration
  def change
    create_table :roster_slots do |t|
      t.belongs_to :team, index: true, foreign_key: true
      t.belongs_to :league_position, index: true, foreign_key: true
      t.belongs_to :league_player, index: true, foreign_key: true
      t.integer :status, default: 0
      t.datetime :active_at
      t.datetime :inactive_at

      t.timestamps null: false
    end
  end
end
