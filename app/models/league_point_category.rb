class LeaguePointCategory < ActiveRecord::Base
  belongs_to :league
  belongs_to :point_category
  has_many :point_submissions

  validates :value, presence: true
end
