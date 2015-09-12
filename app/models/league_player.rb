require 'has_points'

class LeaguePlayer < ActiveRecord::Base
  belongs_to :league
  belongs_to :player
  has_many :point_submissions
  has_one :roster_slot
  has_one :team, through: :roster_slot
  has_many :league_players_league_positions
  has_many :league_positions, through: :league_players_league_positions

  include HasPoints

  validates_presence_of :name

  def allowed_league_positions
    return @allowed_league_positions if @allowed_league_positions

    league.flex_positions | league_positions
  end

  attr_writer :playing_as
  def playing_as
    @playing_as || self.league_positions.first
  end
end
