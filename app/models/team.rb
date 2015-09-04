require 'has_points'

class Team < ActiveRecord::Base
  belongs_to :league
  has_many :roster_slots
  has_many :point_submissions

  include HasPoints

  def league_players
    self.roster_slots.map(&:league_player)
  end
end
