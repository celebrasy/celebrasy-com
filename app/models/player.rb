class Player < ActiveRecord::Base
  belongs_to :league_template
  belongs_to :position

  def attrs_for_league_player(league)
    {
      player: self,
      league_position: league.positions.find_by({ title: self.position.title }),
      first_name: self.first_name,
      last_name: self.last_name
    }
  end
end
