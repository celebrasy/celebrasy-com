class LeaguePlayer < ActiveRecord::Base
  belongs_to :league
  belongs_to :league_position
  belongs_to :player

  def self.find_by_full_name(name)
    first, last = name.split(" ", 2)
    find_by({ first_name: first, last_name: last })
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def allowed_league_positions
    return @allowed_league_positions if @allowed_league_positions

    league.flex_positions | [league_position]
  end
end
