class LeaguePlayer < ActiveRecord::Base
  belongs_to :league
  belongs_to :league_position
  belongs_to :player
  has_many :point_submissions

  def name
    "#{first_name} #{last_name}".strip
  end

  def allowed_league_positions
    return @allowed_league_positions if @allowed_league_positions

    league.flex_positions | [league_position]
  end
end
