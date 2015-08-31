class AddStrictPositions < ActiveRecord::Migration
  def change
    add_column :league_positions, :strict, :boolean, default: true
    add_column :positions, :strict, :boolean, default: true
  end
end
