class LeaguePlayersLeaguePosition < ActiveRecord::Base
  belongs_to :league_player
  belongs_to :league_position
end
