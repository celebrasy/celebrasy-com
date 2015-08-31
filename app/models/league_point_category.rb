class LeaguePointCategory < ActiveRecord::Base
  belongs_to :league
  belongs_to :point_category

  validates :value, presence: true
end
