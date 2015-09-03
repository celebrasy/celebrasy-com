class Team < ActiveRecord::Base
  belongs_to :league
  has_many :roster_slots
  has_many :league_players, through: :roster_slots
  has_many :point_submissions
end
