require 'has_points'

class LeaguePlayer < ActiveRecord::Base
  belongs_to :league
  belongs_to :league_position
  belongs_to :player
  has_many :point_submissions
  has_one :roster_slot
  has_one :team, through: :roster_slot

  include HasPoints

  validates_presence_of :name

  def allowed_league_positions
    return @allowed_league_positions if @allowed_league_positions

    league.flex_positions | [league_position]
  end

  attr_writer :playing_as
  def playing_as
    @playing_as || self.league_position
  end
end
