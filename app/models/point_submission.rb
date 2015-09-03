class PointSubmission < ActiveRecord::Base
  belongs_to :league
  belongs_to :team
  belongs_to :league_player
  belongs_to :league_point_category

  before_save :set_defaults

  enum status: [ :submitted, :approved, :rejected ]

  private

  def set_defaults
    self.points ||= self.league_point_category.try(:value)
    self.status ||= 0
  end
end
