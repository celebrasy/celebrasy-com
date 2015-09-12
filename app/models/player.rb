class Player < ActiveRecord::Base
  belongs_to :league_template
  has_many :players_positions
  has_many :positions, through: :players_positions

  def attrs_for_league_player(league)
    {
      player: self,
      league_positions: league.positions.where({ title: self.positions.map(&:title) }),
      name: self.name
    }
  end
end
